import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_LK',
      symbol: 'Rs. ',
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
}
