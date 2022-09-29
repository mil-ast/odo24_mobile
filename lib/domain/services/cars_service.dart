import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_create_model.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';

class CarsService extends ServicesCore {
  static final CarsService _singleton = CarsService._internal();
  late final Query<CarModel> _query;

  CarsService._internal() {
    _query = FirebaseFirestore.instance
        .collection('cars')
        .withConverter<CarModel>(
          fromFirestore: (snapshot, _) => CarModel.fromJson(snapshot.data()!),
          toFirestore: (car, _) => car.toJson(),
        )
        .where('uid', isEqualTo: userID);
  }

  factory CarsService() {
    return _singleton;
  }

  Stream<QuerySnapshot<CarModel>> get listener {
    return _query.snapshots();
  }

  Future<List<QueryDocumentSnapshot<CarModel>>> getAllMyCars() async {
    final result = await _query.get();
    if (result.docs.isEmpty) {
      return [];
    }

    return result.docs;
  }

  Future<void> create(CarModel car) {
    final model = CarCreateModel(car.name, car.odo, userID, withAvatar: car.withAvatar);

    return FirebaseFirestore.instance.collection('cars').add(model.toJson());
  }
}
