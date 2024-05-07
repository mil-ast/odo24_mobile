import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

abstract interface class ICarsDataProvider {
  Future<List<CarModel>> getMyCars();
  Future<CarModel?> create(CarCreateRequestModel body);
  Future<void> update(CarUpdateRequestModel body);
}

class CarsDataProvider implements ICarsDataProvider {
  final Dio _httpClient;

  CarsDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<CarModel>> getMyCars() async {
    final api = _httpClient.get('/api/cars');
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => CarModel.fromJson(e)).toList();
  }

  @override
  Future<CarModel?> create(CarCreateRequestModel body) async {
    final api = _httpClient.post('/api/cars', data: body);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      return null;
    }
    return CarModel.fromJson(json);
  }

  @override
  Future<void> update(CarUpdateRequestModel body) async {
    await _httpClient.put('/api/cars/${body.carID}', data: body);
  }
}
