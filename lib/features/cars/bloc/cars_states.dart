import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

sealed class CarsState {
  const CarsState();

  factory CarsState.ready() = CarsReadyState;
  factory CarsState.idle() = CarsWaitingState;
  factory CarsState.failure(Object err) = CarsErrorState;
  factory CarsState.loaded(List<CarModel> cars) = CarsLoadedState;
  factory CarsState.actionSelect(CarModel car) => CarActionSelectState(car);
  factory CarsState.actionCreate() => const CarActionShowCreateDialogState();
  factory CarsState.actionEdit(CarModel car) => CarActionShowUpdateDialogState(car);
  factory CarsState.actionEditMiliage(CarModel car) => CarActionShowUpdateMiliageDialogState(car);
  factory CarsState.actionDelete(CarModel car) => CarActionShowDeleteDialogState(car);
  factory CarsState.createSuccess() = CarCreateSuccessState;
  factory CarsState.updateSuccess() = CarUpdateSuccessState;
  factory CarsState.deleteSuccess() = CarDeleteSuccessState;

  bool get needBuild => switch (this) {
    CarsReadyState() => true,
    CarsWaitingState() => true,
    CarsErrorState() => true,
    CarsLoadedState() => true,
    CarActionSelectState() => false,
    CarActionShowCreateDialogState() => false,
    CarActionShowUpdateDialogState() => false,
    CarActionShowUpdateMiliageDialogState() => false,
    CarActionShowDeleteDialogState() => false,
    CarCreateSuccessState() => false,
    CarUpdateSuccessState() => false,
    CarDeleteSuccessState() => false,
  };
}

class CarsReadyState extends CarsState {
  const CarsReadyState();
}

class CarsWaitingState extends CarsState {
  const CarsWaitingState();
}

class CarsErrorState extends CarsState {
  final String message;
  CarsErrorState(Object err) : message = err.toString();
}

class CarsLoadedState extends CarsState {
  final List<CarModel> cars;
  CarsLoadedState(this.cars);
}

class CarActionSelectState extends CarsState {
  final CarModel car;
  const CarActionSelectState(this.car);
}

class CarActionShowCreateDialogState extends CarsState {
  const CarActionShowCreateDialogState();
}

class CarActionShowUpdateDialogState extends CarsState {
  final CarModel car;
  const CarActionShowUpdateDialogState(this.car);
}

class CarActionShowUpdateMiliageDialogState extends CarsState {
  final CarModel car;
  const CarActionShowUpdateMiliageDialogState(this.car);
}

class CarActionShowDeleteDialogState extends CarsState {
  final CarModel car;
  const CarActionShowDeleteDialogState(this.car);
}

class CarCreateSuccessState extends CarsState {
  const CarCreateSuccessState();
}

class CarUpdateSuccessState extends CarsState {
  const CarUpdateSuccessState();
}

class CarDeleteSuccessState extends CarsState {
  const CarDeleteSuccessState();
}
