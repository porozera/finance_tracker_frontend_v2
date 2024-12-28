import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(
      double amount, {
        String? symbol = "₹",
        String? name = "IDR",
        String? locale = "id_ID",
      }) {
    return NumberFormat('$symbol###,###,###,###.####', locale).format(amount);
  }
}

