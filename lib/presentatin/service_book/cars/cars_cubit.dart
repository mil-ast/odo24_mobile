import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/cars/cars.service.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarsCubit extends Cubit<AppState> {
  final _service = CarsService();

  CarsCubit() : super(AppStateDefault());

  void getAllCars() async {
    emit(AppStateLoading());
    final cars = await _service.getAll();
    emit(CarsState(cars));
  }

  void onClickUpdateCar(QueryDocumentSnapshot car) {
    emit(OnUpdateCarState(car));
  }

  void onClickDeleteCar(QueryDocumentSnapshot car) {
    emit(OnDeleteCarState(car));
  }

  void delete(QueryDocumentSnapshot car) {}
}

class CarsStateBuilder implements AppState {}

class CarsState implements CarsStateBuilder {
  final List<CarModel> cars;
  const CarsState(this.cars);
}

class CarsCreateFirstCarState implements AppState {}

class OnUpdateCarState extends AppState {
  final QueryDocumentSnapshot car;
  OnUpdateCarState(this.car);
}

class OnDeleteCarState extends AppState {
  final QueryDocumentSnapshot car;
  OnDeleteCarState(this.car);
}
