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

  void openCheckout({
    required String keyId,
    required String orderId,
    required int amount,
    required String planId,
    String? planTitle,
    String? userEmail,
    String? userPhone,
  }) {
    final razorpay = _razorpay;
    if (razorpay == null) return;

    final prefill = <String, String>{};
    if (userEmail != null && userEmail.isNotEmpty) {
      prefill['email'] = userEmail;
    }
    if (userPhone != null && userPhone.isNotEmpty) {
      prefill['contact'] = userPhone;
    }

    final options = <String, dynamic>{
      'key': keyId.isNotEmpty ? keyId : RazorpayConfig.defaultKeyId,
      'order_id': orderId,
      'amount': amount,
      'name': RazorpayConfig.merchantName,
      'description': planTitle != null && planTitle.isNotEmpty
          ? '$planTitle Plan — Premium Access'
          : 'Premium Subscription',
      'theme': <String, String>{'color': '#2563EB'},
      'modal': <String, dynamic>{
        'confirm_close': true,
      },
      'notes': <String, String>{
        'package_id': planId,
      },
    };

    if (prefill.isNotEmpty) {
      options['prefill'] = prefill;
    }

    razorpay.open(options);
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
