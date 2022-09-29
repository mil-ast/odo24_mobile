import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:odo24_mobile/core/app_state_core.dart';

class ServicesCore<T> {
  String get userID {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw AppStateError('empty_uuid', 'Ошибка авторизации');
    }
    return uid;
  }

  DatabaseReference getRefCurrenUser(String key) {
    return FirebaseDatabase.instance.ref("$userID$key");
  }

  List<Map<String, dynamic>> listObjectToListMap(List<Object?> result) {
    return result.cast<dynamic>().map((e) => Map<String, dynamic>.from(e as dynamic)).toList();
  }
}
