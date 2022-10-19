import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/constants/database_constants.dart';
import 'package:odo24_mobile/core/services_core.dart';

class GroupsCubit extends Cubit<AppState> {
  GroupsCubit() : super(AppStateDefault());

  Stream<QuerySnapshot<Map<String, dynamic>>> getAll() {
    return FirebaseFirestore.instance
        .collection(groupsCollection)
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .snapshots();
  }
}
