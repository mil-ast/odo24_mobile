import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

sealed class CarsState {
  final bool needBuild;
  const CarsState(this.needBuild);

  factory CarsState.ready() = CarsReadyState;
  factory CarsState.idle() = CarsWaitingState;
  factory CarsState.failure(Object err) = CarsErrorState;
  factory CarsState.loaded(List<CarModel> cars) = CarsLoadedState;
  factory CarsState.actionSelect(CarModel car) => CarActionState(CarAction.select, car: car);
  factory CarsState.actionCreate() => CarActionState(CarAction.create);
  factory CarsState.actionEdit(CarModel car) => CarActionState(CarAction.edit, car: car);
  factory CarsState.actionEditMiliage(CarModel car) => CarActionState(CarAction.editMiliage, car: car);
  factory CarsState.createSuccess() = CarCreateSuccessState;
  factory CarsState.updateSuccess() = CarUpdateSuccessState;
}

enum CarAction {
  select,
  edit,
  editMiliage,
  delete,
  create,
}

class CarsReadyState extends CarsState {
  const CarsReadyState() : super(true);
}

class CarsWaitingState extends CarsState {
  const CarsWaitingState() : super(true);
}

class CarsErrorState extends CarsState {
  final String message;
  CarsErrorState(Object err)
      : message = err.toString(),
        super(false);
}

class CarsLoadedState extends CarsState {
  final List<CarModel> cars;
  CarsLoadedState(this.cars) : super(true);
}

class CarActionState extends CarsState {
  final CarModel? car;
  final CarAction action;
  CarActionState(this.action, {this.car}) : super(false);
}

class CarCreateSuccessState extends CarsState {
  CarCreateSuccessState() : super(false);
}

class CarUpdateSuccessState extends CarsState {
  CarUpdateSuccessState() : super(false);
}
