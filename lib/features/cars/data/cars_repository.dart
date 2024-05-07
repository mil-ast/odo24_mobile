import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';
import 'package:odo24_mobile/features/cars/data/cars_data_provider.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

abstract interface class ICarsRepository {
  Future<List<CarModel>> getMyCars();
  Future<CarModel> create(CarCreateRequestModel body);
  Future<void> update(CarUpdateRequestModel body);
}

class CarsRepository implements ICarsRepository {
  final ICarsDataProvider _carsDataProvider;

  CarsRepository({
    required ICarsDataProvider carsDataProvider,
  }) : _carsDataProvider = carsDataProvider;

  @override
  Future<List<CarModel>> getMyCars() {
    return _carsDataProvider.getMyCars();
  }

  @override
  Future<CarModel> create(CarCreateRequestModel body) async {
    final result = await _carsDataProvider.create(body);
    if (result == null) {
      throw Exception('Произошла ошибка при создании авто');
    }
    return result;
  }

  @override
  Future<void> update(CarUpdateRequestModel body) {
    return _carsDataProvider.update(body);
  }
}
