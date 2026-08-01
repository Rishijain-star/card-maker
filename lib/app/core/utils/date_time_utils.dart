
import 'package:intl/intl.dart';

class DateTimeUtils {
  String formatDuration(Duration d) {
    final days = d.inDays;
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$days|$minutes|$seconds'; // Custom format for splitting in UI
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(dateTime); // 13 Jan 2024
    } catch (e) {
      return dateString; // agar parsing me error aaya to original return kar do
    }
  }
  // Example: 2025-10-01T13:04:00 -> 01 Oct 2025, 01:04 PM
  static String formatDateTime(String? dateTimeStr, {String pattern = 'dd MMM yyyy, hh:mm a'}) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat(pattern).format(dt);
    } catch (e) {
      return dateTimeStr; // fallback
    }
  }

  static String getRemainingTime(String? expiryDate) {
    if (expiryDate == null) {
      return "NEVER EXPIRE";
    }

    try {
      final expiry = DateTime.parse(expiryDate).toUtc();
      final now = DateTime.now().toUtc();

      final difference = expiry.difference(now);

      if (difference.isNegative) {
        return "Expired";
      }

      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;

      if (days > 0 && hours > 0) {
        return "$days days $hours hr";
      } else if (days > 0) {
        return "$days days";
      } else if (hours > 0) {
        return "$hours hr";
      } else if (minutes > 0) {
        return "$minutes min";
      } else {
        return "Less than 1 min";
      }
    } catch (e) {
      return "NEVER EXPIRE";
    }
  }
}
