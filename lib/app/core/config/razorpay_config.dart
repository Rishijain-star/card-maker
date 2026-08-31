/// Razorpay plans and merchant configuration.
abstract final class RazorpayConfig {
  static const String defaultKeyId = 'rzp_test_TTUgXMYG7fJ7Wc';
  static const String merchantName = 'ID-Shaydi';

  static const String planStartup = 'startup';
  static const String planBasic = 'basic';
  static const String planYearly = 'yearly';

  static const int freeSaveLimit = 5;
  static const int startupSaveLimit = 500;
  static const int basicSaveLimit = 2500;
  static const int yearlySaveLimit = 35000;

  static const List<RazorpayPlanItem> plans = [
    RazorpayPlanItem(
      id: planStartup,
      title: 'Startup',
      price: '₹118',
      period: '/month',
      saveLimit: startupSaveLimit,
      description: 'Save up to 500 cards (30 days)',
      isPopular: false,
      tag: null,
    ),
    RazorpayPlanItem(
      id: planBasic,
      title: 'Basic',
      price: '₹236',
      period: '/month',
      saveLimit: basicSaveLimit,
      description: 'Save up to 2,500 cards (30 days)',
      isPopular: true,
      tag: 'POPULAR',
    ),
    RazorpayPlanItem(
      id: planYearly,
      title: 'Yearly',
      price: '₹2,124',
      originalPrice: '₹2,832',
      period: '/year',
      saveLimit: yearlySaveLimit,
      description: '35,000 Cards + 5,000 Extra Cards Bonus (365 days)',
      isPopular: false,
      tag: '25% OFF',
      bonusText: '+5,000 Extra Cards Bonus',
    ),
  ];
}

class RazorpayPlanItem {
  final String id;
  final String title;
  final String price;
  final String? originalPrice;
  final String period;
  final int saveLimit;
  final String description;
  final bool isPopular;
  final String? tag;
  final String? bonusText;

  const RazorpayPlanItem({
    required this.id,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.period,
    required this.saveLimit,
    required this.description,
    required this.isPopular,
    this.tag,
    this.bonusText,
  });
}
