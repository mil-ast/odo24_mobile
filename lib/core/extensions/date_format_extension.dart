import 'package:intl/intl.dart';

final _dtFormat = DateFormat.yMMMMd();

extension NumberFormatExtension on DateTime {
  String yMMMMd() {
    return _dtFormat.format(this);
  }
}
