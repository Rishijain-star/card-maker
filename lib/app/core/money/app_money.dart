import 'package:intl/intl.dart';

/// Business amounts are denominated in SEK (shown globally for clarity).
class AppMoney {
  AppMoney._();

  static String formatSek(num amount) {
    return NumberFormat.currency(locale: 'sv_SE', symbol: 'kr', decimalDigits: 0)
        .format(amount);
  }
}
