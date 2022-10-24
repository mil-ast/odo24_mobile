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
        .orderBy('sort', descending: false)
        .snapshots();
  }

  void delete(QueryDocumentSnapshot group) {
    final batch = FirebaseFirestore.instance.batch();

    batch.delete(group.reference);
    group.reference.collection(servicesCollection).get().then((services) {
      services.docs.forEach((service) {
        batch.delete(service.reference);
      });
    }).then((value) => batch.commit());
  }

  Future<void> saveOrder(List<QueryDocumentSnapshot> groups) {
    final batch = FirebaseFirestore.instance.batch();

    for (int index = 0; index < groups.length; index++) {
      batch.update(groups[index].reference, {'sort': index});
    }

    return batch.commit();
  }

  void onClickUpdateGroup(QueryDocumentSnapshot group) {
    emit(OnUpdateGroupState(group));
  }

  void onClickDeleteGroup(QueryDocumentSnapshot group) {
    emit(OnDeleteGroupState(group));
  }
}

class OnUpdateGroupState extends AppState {
  final QueryDocumentSnapshot group;
  OnUpdateGroupState(this.group);
}

class OnDeleteGroupState extends AppState {
  final QueryDocumentSnapshot group;
  OnDeleteGroupState(this.group);
}
