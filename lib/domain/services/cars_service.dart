import 'package:firebase_database/firebase_database.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';

class CarsService extends ServicesCore {
  Future<List<CarModel>> getAllMyCars() {
    final ref = super.getRefCurrenUser('/cars');

    return ref.get().then((DataSnapshot snap) {
      if (snap.value == null) {
        return Future.value([]);
      }
      return (snap.value! as Map<String, dynamic>).values.map((e) => CarModel.fromJson(e)).toList();
    });
  }
}
