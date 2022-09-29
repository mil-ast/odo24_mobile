import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/services/cars_service.dart';

class HomeCubit extends Cubit<AppState> {
  final CarsService _carsService = CarsService();

  HomeCubit() : super(AppStateLoading());

  void getAllCars() {
    emit(AppStateLoading());

    _carsService.getAllMyCars().then((List<QueryDocumentSnapshot<CarModel>> cars) {
      if (cars.isEmpty) {
        emit(HomeCreateFirstCarState());
        return;
      }
      emit(HomeCarStateSuccess(cars));
    }).catchError((e) {
      emit(AppStateError(
        'car_get_error',
        'Произошла ошибка при получении авто',
        details: e.toString(),
      ));
    });
  }
}

class HomeCreateFirstCarState extends AppState {}

class HomeCarStateSuccess extends AppState {
  final List<QueryDocumentSnapshot<CarModel>> cars;
  HomeCarStateSuccess(this.cars);
}
