import 'package:intl/intl.dart';

final _numberFormat = NumberFormat.decimalPattern();
final _currencyFormat = NumberFormat.currency(decimalDigits: 0, symbol: '₽');

extension NumberFormatExtension on int {
  String format() {
    return _numberFormat.format(this);
  }

  String currency() {
    return _currencyFormat.format(this);
  }
}
