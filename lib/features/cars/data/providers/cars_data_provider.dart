import 'package:dio/dio.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

abstract interface class ICarsDataProvider {
  Future<Response<Object>> getMyCars();
  Future<Response<Object>> create(CarCreateRequestModel body);
  Future<Response<void>> update(CarUpdateRequestModel body);
}

class CarsDataProvider implements ICarsDataProvider {
  final Dio _httpClient;

  CarsDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<Response<Object>> getMyCars() async {
    return _httpClient.get('/api/cars');
  }

  @override
  Future<Response<Object>> create(CarCreateRequestModel body) {
    return _httpClient.post('/api/cars', data: body);
  }

  @override
  Future<Response<dynamic>> update(CarUpdateRequestModel body) {
    return _httpClient.put('/api/cars/${body.carID}', data: body);
  }
}
