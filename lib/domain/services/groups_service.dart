import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_create_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';
import 'package:odo24_mobile/domain/models/services/service_model.dart';

class GroupsService extends ServicesCore {
  static final GroupsService _singleton = GroupsService._internal();
  final _baseCollectionName = 'groups';
  late final CollectionReference<GroupModel> _query;

  GroupsService._internal() {
    _query = FirebaseFirestore.instance.collection(_baseCollectionName).withConverter<GroupModel>(
          fromFirestore: (snapshot, _) => GroupModel.fromJson(snapshot.data()!),
          toFirestore: (car, _) => car.toJson(),
        );
  }

  factory GroupsService() {
    return _singleton;
  }

  Stream<QuerySnapshot<GroupModel>> get listener {
    return _query.snapshots();
  }

  CollectionReference<GroupModel> get query {
    return _query;
  }

  Future<void> create(String groupName) {
    final group = GroupCreateModel(name: groupName, uid: userID);
    return FirebaseFirestore.instance.collection(_baseCollectionName).add(group.toJson());
  }

  Stream<QuerySnapshot<ServiceModel>> getServicesByCar(
      QueryDocumentSnapshot<CarModel> car, QueryDocumentSnapshot<GroupModel> group) {
    return group.reference
        .collection('services')
        .withConverter<ServiceModel>(
          fromFirestore: (snapshot, _) => ServiceModel.fromJson(snapshot.data()!),
          toFirestore: (service, _) => service.toJson(),
        )
        .where('car_ref', isEqualTo: car.reference)
        .snapshots();
    /*return car.reference
        .collection(_baseServicesCollectionName)
        .withConverter<ServiceModel>(
          fromFirestore: (snapshot, _) => ServiceModel.fromJson(snapshot.data()!),
          toFirestore: (service, _) => service.toJson(),
        )
        .where('car_ref', isEqualTo: car.id)
        .snapshots();*/
  }
}
