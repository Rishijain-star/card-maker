import 'package:flutter/services.dart';

/// Formats typed digits as `dd-mm-yyyy` (e.g. 11-10-1888).
class DdMmYyyyDashInputFormatter extends TextInputFormatter {
  const DdMmYyyyDashInputFormatter();

  static const int _maxDigits = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed =
        digits.length > _maxDigits ? digits.substring(0, _maxDigits) : digits;

    final formatted = _formatDigits(trimmed);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatDigits(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('-');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

/// `dd-mm-yyyy` helpers for date pickers and display fields.
class DdMmYyyyDash {
  DdMmYyyyDash._();

  static String format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  static DateTime? parse(String value) {
    final parts = value.trim().split('-');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    return DateTime(year, month, day);
  }
}
