/// Razorpay test keys — replace from Dashboard → Test Mode → API Keys.
abstract final class RazorpayConfig {
  static const String keyId = 'rzp_test_1DP5mmOlF5G5ag';

  /// ₹199 in paise.
  static const int premiumAmountPaise = 19900;

  static const String merchantName = 'ID-Shaydi';
  static const String premiumDescription = 'Premium Subscription — save up to 500 templates';

  static const int premiumSaveLimit = 500;
}
