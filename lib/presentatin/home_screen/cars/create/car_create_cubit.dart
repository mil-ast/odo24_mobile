import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/cars/car_create_dto.dart';
import 'package:odo24_mobile/services/cars/cars.service.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarCreateCubit extends Cubit<AppState> {
  final _service = CarsService();

  CarCreateCubit() : super(AppStateDefault());

  void create(CarCreateDTO body) async {
    emit(AppStateLoading());

    try {
      final result = await _service.create(body);
      emit(CarCreateSuccess(result));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}

class CarCreateSuccess extends AppStateSuccess<CarModel> {
  CarCreateSuccess(super.data);
}
