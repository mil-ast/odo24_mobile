import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/cars/car_update_dto.dart';
import 'package:odo24_mobile/services/cars/cars.service.dart';

class CarUpdateCubit extends Cubit<AppState> {
  final _service = CarsService();

  CarUpdateCubit() : super(AppStateDefault());

  void update(CarUpdateDTO body) async {
    emit(AppStateLoading());

    try {
      await _service.update(body);
      emit(AppStateSuccess());
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}
