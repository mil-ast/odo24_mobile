import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UtilsCore {
  static String formatDt(DateTime? dt, {String format = 'dd.MM.yyyy'}) {
    if (dt == null) {
      return '';
    }

    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dt);
  }

  static String formatTimestamp(Timestamp? ts, {String format = 'dd.MM.yyyy'}) {
    if (ts == null) {
      return '';
    }

    final dt = ts.toDate();

    return formatDt(dt, format: format);
  }
}
