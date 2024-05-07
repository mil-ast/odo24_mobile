import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarsCubit extends Cubit<CarsState> {
  final ICarsRepository _carsRepository;
  final List<CarModel> _cars = [];

  CarsCubit({
    required ICarsRepository carsRepository,
  })  : _carsRepository = carsRepository,
        super(CarsState.ready());

  void getAllCars() async {
    try {
      emit(CarsState.idle());
      final cars = await _carsRepository.getMyCars();
      _cars.clear();
      _cars.addAll(cars);
      _cars.sort((a, b) => b.carID - a.carID);
      emit(CarsState.loaded(_cars));
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

  Future<void> create(CarCreateRequestModel model) async {
    try {
      final newCar = await _carsRepository.create(model);
      _cars.insert(0, newCar);
      emit(CarsState.createSuccess());
      emit(CarsState.loaded(_cars));
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
}
