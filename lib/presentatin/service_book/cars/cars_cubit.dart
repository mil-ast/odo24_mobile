import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/constants/database_constants.dart';

class CarsCubit extends Cubit<AppState> {
  CarsCubit() : super(AppStateDefault());

  Future getAllCars() {
    /* return FirebaseFirestore.instance
        .collection(carsCollection)
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .snapshots(); */
    return Future.value();
  }

  void onClickUpdateCar(QueryDocumentSnapshot car) {
    emit(OnUpdateCarState(car));
  }

  void onClickDeleteCar(QueryDocumentSnapshot car) {
    emit(OnDeleteCarState(car));
  }

  void delete(QueryDocumentSnapshot car) {
    final batch = FirebaseFirestore.instance.batch();

    batch.delete(car.reference);

    FirebaseFirestore.instance
        .collection(groupsCollection)
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .get()
        .then((groups) {
      final List<Future<QuerySnapshot>> listServices = [];
      groups.docs.forEach((group) {
        listServices
            .add(group.reference.collection(servicesCollection).where('car_ref', isEqualTo: car.reference).get());
      });
      return Future.wait(listServices);
    }).then((services) {
      services.forEach((service) {
        service.docs.forEach((service) {
          batch.delete(service.reference);
        });
      });

      return batch.commit();
    });
  }
}

class CarsCreateFirstCarState extends AppState {}

class OnUpdateCarState extends AppState {
  final QueryDocumentSnapshot car;
  OnUpdateCarState(this.car);
}

class OnDeleteCarState extends AppState {
  final QueryDocumentSnapshot car;
  OnDeleteCarState(this.car);
}
