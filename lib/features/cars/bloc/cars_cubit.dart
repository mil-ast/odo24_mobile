import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

class CarsCubit extends Cubit<CarsState> {
  final ICarsRepository _carsRepository;

  CarsCubit({required this._carsRepository}) : super(CarsState.ready());

  Future<void> getAllCars() async {
    try {
      emit(CarsState.idle());
      final cars = (await _carsRepository.getMyCars())..sort();
      emit(CarsState.loaded(cars));
    } catch (e) {
      emit(CarsState.failure(e));
      rethrow;
    }
  }

  void onSelectCar(CarModel car) {
    emit(CarsState.actionSelect(car));
  }

  void openFormCreateCar() {
    emit(CarsState.actionCreate());
  }

  void openFormEditCar(CarModel car) {
    emit(CarsState.actionEdit(car));
  }

  void openFormEditODO(CarModel car) {
    emit(CarsState.actionEditMiliage(car));
  }

  void onClickDeleteCar(CarModel car) {
    emit(CarsState.actionDelete(car));
  }

  Future<void> create(CarCreateRequestModel model) async {
    try {
      await _carsRepository.create(model);
      emit(CarsState.createSuccess());

      final cars = (await _carsRepository.getMyCars())..sort();
      emit(CarsState.loaded(cars));
    } catch (e) {
      emit(CarsState.failure(e));
      rethrow;
    }
  }

  Future<void> edit(CarUpdateRequestModel model) async {
    try {
      await _carsRepository.update(model);
      emit(CarsState.updateSuccess());
      getAllCars();
    } catch (e) {
      emit(CarsState.failure(e));
      rethrow;
    }
  }

  Future<void> updateODO(int carID, int odo) async {
    try {
      await _carsRepository.updateODO(carID, odo);
      emit(CarsState.updateSuccess());
      getAllCars();
    } catch (e) {
      emit(CarsState.failure(e));
      rethrow;
    }
  }

  Future<void> delete(CarModel car) async {
    try {
      await _carsRepository.delete(car);
      emit(CarsState.deleteSuccess());
      getAllCars();
    } catch (e) {
      emit(CarsState.failure(e));
      rethrow;
    }
  }
}
