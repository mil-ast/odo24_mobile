import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/services_core.dart';

class CarsCubit extends Cubit<AppState> {
  CarsCubit() : super(AppStateDefault());

  Stream<QuerySnapshot> getAllCars() {
    return FirebaseFirestore.instance
        .collection('cars')
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .snapshots();
  }

  void onClickUpdateCar(QueryDocumentSnapshot car) {
    emit(OnUpdateCarState(car));
  }
}

class CarsCreateFirstCarState extends AppState {}

class OnUpdateCarState extends AppState {
  final QueryDocumentSnapshot car;
  OnUpdateCarState(this.car);
}
