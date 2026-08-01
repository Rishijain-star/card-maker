import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/config/razorpay_config.dart';

typedef PaymentSuccessHandler = void Function(PaymentSuccessResponse response);
typedef PaymentFailureHandler = void Function(PaymentFailureResponse response);

class RazorpayPaymentService {
  Razorpay? _razorpay;
  PaymentSuccessHandler? _onSuccess;
  PaymentFailureHandler? _onFailure;

  void init({
    required PaymentSuccessHandler onSuccess,
    required PaymentFailureHandler onFailure,
  }) {
    dispose();
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _razorpay = Razorpay();
    _razorpay!
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handleFailure)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openPremiumCheckout() {
    final razorpay = _razorpay;
    if (razorpay == null) return;

    razorpay.open(<String, dynamic>{
      'key': RazorpayConfig.keyId,
      'amount': RazorpayConfig.premiumAmountPaise,
      'name': RazorpayConfig.merchantName,
      'description': RazorpayConfig.premiumDescription,
      'theme': <String, String>{'color': '#2563EB'},
      'notes': <String, String>{
        'plan': 'premium',
        'mode': 'test',
      },
    });
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

  void _handleFailure(PaymentFailureResponse response) {
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External wallet',
      response.walletName ?? 'Selected',
      snackPosition: SnackPosition.TOP,
    );
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _onSuccess = null;
    _onFailure = null;
  }
}
