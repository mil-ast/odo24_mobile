import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/services/cars_service.dart';

class CarCreateCubit extends Cubit<AppState> {
  final CarsService _carsService = CarsService();

  CarCreateCubit() : super(AppStateDefault());

  void create(CarModel car) {
    emit(AppStateLoading());

    _carsService.create(car).then((_) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'car_create_error',
        'Произошла ошибка при создании авто :(',
        details: e.toString(),
      ));
    });
  }
}
