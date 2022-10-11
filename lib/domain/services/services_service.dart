import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/services/service_model.dart';

class ServicesService extends ServicesCore {
  static final ServicesService _singleton = ServicesService._internal();
  final _baseCollectionName = 'services';
  late final Query<ServiceModel> _query;

  ServicesService._internal() {
    _query = FirebaseFirestore.instance
        .collection(_baseCollectionName)
        .withConverter<ServiceModel>(
          fromFirestore: (snapshot, _) => ServiceModel.fromJson(snapshot.data()!),
          toFirestore: (service, _) => service.toJson(),
        )
        .where('uid', isEqualTo: userID);
  }

  factory ServicesService() {
    return _singleton;
  }

  Stream<QuerySnapshot<ServiceModel>> get listener {
    return _query.snapshots();
  }

  /*Future<List<QueryDocumentSnapshot<ServiceModel>>> getAllServicesByCar(DocumentReference<CarModel> carRef) async {
    final result = await _query.where('car_ref', isEqualTo: carRef).get();
    if (result.docs.isEmpty) {
      return [];
    }

    final uniqGroups = Map<String, String>();
    result.docs.forEach((element) {
      final DocumentReference ref = element.get('group_ref');
      if (!uniqGroups.containsKey(ref.id)) {
        uniqGroups[ref.id] = 
      }
      uniqGroups.add(ref.id);
    });


    final groupQuery = GroupsService().query.doc(uniqGroups.toList());
    groupQuery.

    return result.docs;
  }*/
}
