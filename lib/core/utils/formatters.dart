import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat('#,###', 'en_US');

  static String formatCurrency(num amount) {
    final formatted = _currencyFormat.format(amount);
    return '$formatted ج.م';
  }

  static String formatArea(num m2) {
    return '$m2 م²';
  }

  static bool isValidEgyptianPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    final regex = RegExp(r'^(\+20|0020|0)?1[0125][0-9]{8}$');
    return regex.hasMatch(cleanPhone);
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  static String formatMatchScore(num score) {
    final rounded = score.round();
    return '$rounded%';
  }
}
