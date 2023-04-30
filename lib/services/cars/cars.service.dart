import 'package:odo24_mobile/repository/cars/models/car_create_dto.dart';
import 'package:odo24_mobile/repository/cars/models/car_update_dto.dart';
import 'package:odo24_mobile/repository/cars/cars.repository.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarsService {
  static final _instance = CarsService._internal();

  factory CarsService() {
    return _instance;
  }

  CarsService._internal();

  final _repository = CarsRepository();

  Future<List<CarModel>> getAll() async {
    final result = await _repository.getAll();

    return result.map((dto) => CarModel.fromDTO(dto)).toList();
  }

  Future<CarModel> create(CarCreateDTO car) async {
    final result = await _repository.create(car);
    return CarModel.fromDTO(result);
  }

  Future<void> update(CarUpdateDTO car) {
    return _repository.update(car);
  }

  Future<void> delete(CarModel car) {
    return _repository.delete(car.carID);
  }
}
