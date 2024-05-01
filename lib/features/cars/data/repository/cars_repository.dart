import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';
import 'package:odo24_mobile/features/cars/data/providers/cars_data_provider.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

abstract interface class ICarsRepository {
  Future<List<CarModel>> getMyCars();
  Future<CarModel> create(CarCreateRequestModel body);
  Future<void> update(CarUpdateRequestModel body);
}

class CarsRepository implements ICarsRepository {
  final CarsDataProvider _carsDataProvider;

  CarsRepository({
    required CarsDataProvider carsDataProvider,
  }) : _carsDataProvider = carsDataProvider;

  @override
  Future<List<CarModel>> getMyCars() async {
    final api = _carsDataProvider.getMyCars();
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => CarModel.fromJson(e)).toList();
  }

  @override
  Future<CarModel> create(CarCreateRequestModel body) async {
    final api = _carsDataProvider.create(body);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw Exception('Произошла ошибка при создании авто');
    }
    return CarModel.fromJson(json);
  }

  @override
  Future<void> update(CarUpdateRequestModel body) async {
    await _carsDataProvider.update(body);
  }
}
