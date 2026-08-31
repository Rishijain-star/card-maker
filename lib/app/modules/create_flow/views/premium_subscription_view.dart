import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/config/razorpay_config.dart';
import '../../../core/widgets/top_slide_notice.dart';
import '../../../data/api_repository.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../services/razorpay_payment_service.dart';
import '../controllers/create_flow_controller.dart';

class PremiumSubscriptionView extends StatefulWidget {
  const PremiumSubscriptionView({super.key});

  @override
  State<PremiumSubscriptionView> createState() => _PremiumSubscriptionViewState();
}

class _PremiumSubscriptionViewState extends State<PremiumSubscriptionView>
    with WidgetsBindingObserver {
  final RazorpayPaymentService _paymentService = RazorpayPaymentService();
  bool _paying = false;
  String _selectedPlanId = RazorpayConfig.planYearly;

  CreateFlowController get _flow => Get.find<CreateFlowController>();

  RazorpayPlanItem get _selectedPlan => RazorpayConfig.plans.firstWhere(
        (p) => p.id == _selectedPlanId,
        orElse: () => RazorpayConfig.plans[2],
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _paymentService.init(
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _paymentService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _paying) {
      setState(() => _paying = false);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;

    final orderId = response.orderId ?? '';
    final paymentId = response.paymentId ?? '';
    final signature = response.signature ?? '';

    if (orderId.isEmpty || paymentId.isEmpty || signature.isEmpty) {
      setState(() => _paying = false);
      Get.snackbar(
        'Verification incomplete',
        'Payment details could not be verified with server.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
      );
      return;
    }

    // Call Laravel server-side verification endpoint
    final verifyRes = await ApiRepository.verifyPayment(
      orderId: orderId,
      paymentId: paymentId,
      signature: signature,
    );

    if (!mounted) return;
    setState(() => _paying = false);

    if (verifyRes != null && verifyRes['status'] == true) {
      final data = verifyRes['data'] as Map<String, dynamic>?;
      final plan = data?['premium_plan']?.toString() ?? _selectedPlanId;
      final expiresAt = data?['premium_expires_at']?.toString();

      await _flow.activatePremium(plan: plan, expiresAt: expiresAt);

      if (!mounted) return;
      TopSlideNotice.show(
        context: context,
        title: 'Premium Activated 🎉',
        message:
            'You can now save up to ${_selectedPlan.saveLimit} templates. Thank you!',
      );
      Get.back<void>();
    } else {
      final message = verifyRes?['message']?.toString() ??
          'Payment verification failed. Please contact support.';
      Get.snackbar(
        'Verification Failed',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
      );
    }
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() => _paying = false);
    final message = response.message ?? 'Payment could not be completed.';
    Get.snackbar(
      'Payment cancelled / failed',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
    );
  }

  Future<void> _startPayment() async {
    if (_flow.isPremiumActive && _flow.premiumPlan.value == _selectedPlanId) {
      Get.snackbar(
        'Already Active',
        'Your account already has this Premium plan active.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _paying = true);

    // 1. Call Laravel to create trusted order
    final orderRes = await ApiRepository.createPaymentOrder(
      packageId: _selectedPlanId,
    );

    if (!mounted) return;

    if (orderRes == null || orderRes['status'] != true || orderRes['data'] == null) {
      setState(() => _paying = false);
      final errorMsg = orderRes?['message']?.toString() ??
          'Could not connect to payment server. Please check your connection.';
      Get.snackbar(
        'Order Creation Failed',
        errorMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
      );
      return;
    }

    final data = orderRes['data'] as Map<String, dynamic>;
    final orderId = '${data['order_id'] ?? ''}';
    final amount = (data['amount'] as num?)?.toInt() ?? 0;
    final keyId = '${data['key_id'] ?? ''}';

    final storage = LocalStorageService();
    final email = storage.getEmailId();
    final phone = storage.getUserPhone();

    // 2. Open Razorpay Standard Checkout with server-returned parameters
    _paymentService.openCheckout(
      keyId: keyId,
      orderId: orderId,
      amount: amount,
      planId: _selectedPlanId,
      planTitle: _selectedPlan.title,
      userEmail: email,
      userPhone: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Premium Subscription',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          // Centered Glowing Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose Your Plan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlock high-resolution ID card creation & downloads',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Plan Selection Cards (3 columns)
          Row(
            children: RazorpayConfig.plans.map((plan) {
              final isSelected = _selectedPlanId == plan.id;
              final isYearly = plan.id == RazorpayConfig.planYearly;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: _paying
                        ? null
                        : () => setState(() => _selectedPlanId = plan.id),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isYearly ? const Color(0xFFFFFBEB) : const Color(0xFFEFF6FF))
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? (isYearly ? const Color(0xFFF59E0B) : const Color(0xFF2563EB))
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 2.2 : 1,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: (isYearly
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF2563EB))
                                  .withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (plan.tag != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2.5),
                              decoration: BoxDecoration(
                                gradient: isYearly
                                    ? const LinearGradient(
                                        colors: [Color(0xFFEA580C), Color(0xFFD97706)],
                                      )
                                    : null,
                                color: isYearly ? null : const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                plan.tag!,
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 18),
                          Text(
                            plan.title,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? (isYearly ? const Color(0xFFB45309) : const Color(0xFF2563EB))
                                  : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (plan.originalPrice != null)
                            Text(
                              plan.originalPrice!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          Text(
                            plan.price,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            plan.period,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Plan Details & Benefits Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedPlanId == RazorpayConfig.planYearly
                    ? const Color(0xFFFDE68A)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Plan Summary',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (_selectedPlanId == RazorpayConfig.planYearly)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Text(
                          '25% OFF APPLIED',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _selectedPlan.price,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: _selectedPlanId == RazorpayConfig.planYearly
                            ? const Color(0xFFB45309)
                            : const Color(0xFF2563EB),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _selectedPlan.period,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),

                // Dynamic Plan Benefits
                if (_selectedPlanId == RazorpayConfig.planYearly) ...[
                  const _BenefitRow(
                    icon: Icons.workspace_premium_rounded,
                    text: '35,000 ID Cards Limit (Full 1 Year / 365 Days Access)',
                    isHighlight: true,
                  ),
                  const _BenefitRow(
                    icon: Icons.card_giftcard_rounded,
                    text: '🎁 +5,000 Extra Cards Bonus Included Free',
                    isHighlight: true,
                  ),
                  const _BenefitRow(
                    icon: Icons.local_offer_rounded,
                    text: '🔥 25% Flat Annual Discount (Save More)',
                  ),
                  const _BenefitRow(
                    icon: Icons.hd_outlined,
                    text: 'High-Resolution HD Export (Front & Back)',
                  ),
                  const _BenefitRow(
                    icon: Icons.save_alt_rounded,
                    text: 'Direct Save to My Designs & Phone Gallery',
                  ),
                ] else if (_selectedPlanId == RazorpayConfig.planBasic) ...[
                  const _BenefitRow(
                    icon: Icons.workspace_premium_rounded,
                    text: 'Save up to 2,500 ID Cards (30 Days Validity)',
                    isHighlight: true,
                  ),
                  const _BenefitRow(
                    icon: Icons.hd_outlined,
                    text: 'High-Resolution HD Export (Front & Back)',
                  ),
                  const _BenefitRow(
                    icon: Icons.save_alt_rounded,
                    text: 'Direct Save to My Designs & Phone Gallery',
                  ),
                  const _BenefitRow(
                    icon: Icons.star_outline_rounded,
                    text: 'Access to all Student & Employee ID Templates',
                  ),
                ] else ...[
                  const _BenefitRow(
                    icon: Icons.workspace_premium_rounded,
                    text: 'Save up to 500 ID Cards (30 Days Validity)',
                    isHighlight: true,
                  ),
                  const _BenefitRow(
                    icon: Icons.hd_outlined,
                    text: 'High-Resolution HD Export (Front & Back)',
                  ),
                  const _BenefitRow(
                    icon: Icons.save_alt_rounded,
                    text: 'Direct Save to My Designs & Phone Gallery',
                  ),
                ],

                const SizedBox(height: 18),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _paying ? null : _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPlanId == RazorpayConfig.planYearly
                          ? const Color(0xFFD97706)
                          : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF93C5FD),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _paying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Pay ${_selectedPlan.price} with Razorpay',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Trust Badge & Payment Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF16A34A)),
                    const SizedBox(width: 6),
                    Text(
                      '100% Secure Checkout · UPI (GPay, PhonePe), Cards & NetBanking',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.text,
    this.isHighlight = false,
  });

  final IconData icon;
  final String text;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighlight ? const Color(0xFFD97706) : const Color(0xFF2563EB),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                color: isHighlight ? const Color(0xFF0F172A) : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
