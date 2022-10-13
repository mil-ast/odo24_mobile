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

  /*Future<void> create(ServiceModel car) {
    final model = CarCreateModel(car.name, car.odo, userID, withAvatar: car.withAvatar);

    return FirebaseFirestore.instance.collection('cars').add(model.toJson());
  }*/
}
