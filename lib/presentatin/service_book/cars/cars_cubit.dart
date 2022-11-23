import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/constants/database_constants.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';

class CarsCubit extends Cubit<AppState> {
  final _db = FirebaseFirestore.instance.collection(carsCollection).withConverter(
        fromFirestore: (snapshot, _) => CarModel.fromJson(snapshot.data()),
        toFirestore: (CarModel model, _) => model.toJson(),
      );

  CarsCubit() : super(AppStateDefault());

  /*void loadAllCars() {
    emit(AppStateLoading());

    FirebaseFirestore.instance
        .collection(carsCollection)
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .withConverter(
            fromFirestore: (snapshot, _) => CarModel.fromJson(snapshot.data()),
            toFirestore: (CarModel model, _) => model.toJson())
        .get()
        .then((QuerySnapshot<CarModel> result) {
      carDocList = result.docs.map((e) => e.reference).toList();
      emit(CarsListResultState(carDocList));
    }).catchError((e) {
      emit(AppStateError('cars_get.error', 'Ошибка при получении списка авто'));
    });
  }*/

  Stream<QuerySnapshot<CarModel>> getAllCars() {
    return _db.where('uid', isEqualTo: ProficeServicesCore.userID).snapshots();
  }

  void onClickUpdateCar(QueryDocumentSnapshot<CarModel> doc) {
    emit(OpenUpdateCarDialogState(doc));
  }

  void onClickDeleteCar(QueryDocumentSnapshot<CarModel> car) {
    emit(OpenDeleteCarConfirmDialogState(car));
  }

  Future<void> create(CarModel body) {
    emit(AppStateLoading());

    return FirebaseFirestore.instance
        .collection(carsCollection)
        .withConverter(
            fromFirestore: (snapshot, _) => CarModel.fromJson(snapshot.data()),
            toFirestore: (CarModel model, _) => model.toJson())
        .add(body)
        .then((_) {
      return null;
    }).catchError((e) {
      emit(AppStateError('car_create_error', 'Не удалось добавить авто'));
    });
  }

  void delete(QueryDocumentSnapshot<CarModel> carDoc) {
    emit(AppStateLoading());
    final batch = FirebaseFirestore.instance.batch();

    batch.delete(carDoc.reference);

    FirebaseFirestore.instance
        .collection(groupsCollection)
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .get()
        .then((groups) {
      final List<Future<QuerySnapshot>> listServices = [];
      groups.docs.forEach((group) {
        listServices
            .add(group.reference.collection(servicesCollection).where('car_ref', isEqualTo: carDoc.reference).get());
      });
      return Future.wait(listServices);
    }).then((services) {
      services.forEach((service) {
        service.docs.forEach((service) {
          batch.delete(service.reference);
        });
      });

      return batch.commit();
    }).then((_) {
      //carDocList.remove(carDoc);
      //emit(CarsListResultState(carDocList));
    }).catchError((e) {
      emit(AppStateError('cars.delete', 'Произошла ошибка при удалении авто'));
    });
  }
}

class CarsListResultState extends AppState {
  final List<DocumentReference<CarModel>> carList;
  CarsListResultState(this.carList);
}

class OnCreateCarSuccessState extends AppState {
  final QueryDocumentSnapshot<CarModel> car;
  OnCreateCarSuccessState(this.car);
}

class OpenUpdateCarDialogState extends AppState {
  final QueryDocumentSnapshot<CarModel> car;
  OpenUpdateCarDialogState(this.car);
}

class OpenDeleteCarConfirmDialogState extends AppState {
  final QueryDocumentSnapshot<CarModel> car;
  OpenDeleteCarConfirmDialogState(this.car);
}
