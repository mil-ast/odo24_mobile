import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/cars/models/car_create_dto.dart';
import 'package:odo24_mobile/repository/cars/models/car_update_dto.dart';
import 'package:odo24_mobile/services/cars/cars.service.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarsCubit extends Cubit<AppState> {
  List<CarModel> _carList = [];

  final _service = CarsService();

  CarsCubit() : super(AppStateDefault());

  void getAllCars() async {
    emit(AppStateLoading());
    final cars = await _service.getAll();
    _carList = cars;

    emit(CarsState(cars: cars));
  }

  void onClickCreateCar() {
    emit(ShowCreateCarState());
  }

  void onClickUpdateCar(CarModel car) {
    emit(ShowUpdateCarState(car));
  }

  void onClickDeleteCar(CarModel car) {
    emit(ConfirmationDeleteCarState(car));
  }

  void create(CarCreateDTO body) async {
    emit(AppStateLoading());

    try {
      final result = await _service.create(body);
      _carList.add(result);

      emit(CarCreateSuccessState(result));

      refreshCarList();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void update(CarModel car, CarUpdateDTO body) async {
    emit(AppStateLoading());

    try {
      await _service.update(body);

      car.name = body.name;
      car.odo = body.odo;
      car.avatar = body.avatar;

      emit(CarUpdateSuccessState());
      refreshCarList();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void delete(CarModel car) async {
    try {
      await _service.delete(car);
      final indexCar = _carList.indexOf(car);
      _carList.removeAt(indexCar);

      if (_carList.isNotEmpty) {
        refreshCarList();
      } else {
        emit(CarsState(
          cars: _carList,
        ));
      }
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void onCreateCar(CarModel car) {
    _carList.add(car);
    refreshCarList();
  }

  void refreshCarList() {
    emit(CarsState(cars: _carList));
  }
}

abstract class BuildCarsState extends AppState {}

abstract class ListenCarsState extends AppState {}

class CarsState implements BuildCarsState {
  final List<CarModel> cars;
  const CarsState({
    required this.cars,
  });
}

class ShowCreateCarState implements ListenCarsState {}

class CarCreateSuccessState implements ListenCarsState {
  final CarModel car;
  const CarCreateSuccessState(this.car);
}

class CarUpdateSuccessState implements ListenCarsState {}

class ShowUpdateCarState implements ListenCarsState {
  final CarModel car;
  const ShowUpdateCarState(this.car);
}

class ConfirmationDeleteCarState implements ListenCarsState {
  final CarModel car;
  const ConfirmationDeleteCarState(this.car);
}
