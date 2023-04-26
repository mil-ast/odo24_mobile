import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/cars/cars.service.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarsCubit extends Cubit<AppState> {
  List<CarModel> _carList = [];
  int _selecterCar = -1;

  final _service = CarsService();

  CarsCubit() : super(AppStateDefault());

  void getAllCars() async {
    emit(AppStateLoading());
    final cars = await _service.getAll();
    _carList = cars;

    if (_selecterCar == -1) {
      _selecterCar = 0;
    }
    emit(CarsState(
      cars: cars,
      selectedIndex: _selecterCar,
    ));
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

  void delete(CarModel car) async {
    try {
      await _service.delete(car);
      final indexCar = _carList.indexOf(car);
      _carList.removeAt(indexCar);

      if (_carList.isNotEmpty) {
        selectCar(_carList.first);
      } else {
        _selecterCar = -1;
        emit(CarsState(
          cars: _carList,
          selectedIndex: _selecterCar,
        ));
      }
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void selectCar(CarModel car) {
    _selecterCar = _carList.indexOf(car);
    refreshCarList();
  }

  void onCreateCar(CarModel car) {
    _carList.add(car);
    _selecterCar = _carList.indexOf(car);
    refreshCarList();
  }

  void refreshCarList() {
    emit(CarsState(cars: _carList, selectedIndex: _selecterCar));
  }
}

abstract class BuildCarsState extends AppState {}

abstract class ListenCarsState extends AppState {}

class CarsState implements BuildCarsState {
  final List<CarModel> cars;
  final int selectedIndex;
  const CarsState({
    required this.cars,
    this.selectedIndex = -1,
  });
}

class ShowCreateCarState implements ListenCarsState {}

class ShowUpdateCarState implements ListenCarsState {
  final CarModel car;
  const ShowUpdateCarState(this.car);
}

class ConfirmationDeleteCarState implements ListenCarsState {
  final CarModel car;
  const ConfirmationDeleteCarState(this.car);
}
