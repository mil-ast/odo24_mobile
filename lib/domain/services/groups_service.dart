import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/groups/group_create_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';

class GroupsService extends ServicesCore {
  static final GroupsService _singleton = GroupsService._internal();
  final _baseCollectionName = 'groups';
  late final Query<GroupModel> _query;

  GroupsService._internal() {
    _query = FirebaseFirestore.instance
        .collection(_baseCollectionName)
        .withConverter<GroupModel>(
          fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
          toFirestore: (car, _) => car.toJson(),
        )
        .where('uid', isEqualTo: userID);
  }

  factory GroupsService() {
    return _singleton;
  }

  Stream<QuerySnapshot<GroupModel>> get listener {
    return _query.snapshots();
  }

  Future<List<QueryDocumentSnapshot<GroupModel>>> getAllMyCars() async {
    final result = await _query.get();
    if (result.docs.isEmpty) {
      return [];
    }

    return result.docs;
  }

  Future<void> create(String groupName) {
    final group = GroupCreateModel(name: groupName, uid: userID);
    return FirebaseFirestore.instance.collection(_baseCollectionName).add(group.toJson());
  }
}
