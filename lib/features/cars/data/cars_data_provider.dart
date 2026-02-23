import 'package:http/http.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

abstract interface class ICarsDataProvider {
  Future<List<CarModel>> getMyCars();
  Future<CarModel?> create(CarCreateRequestModel body);
  Future<void> update(CarUpdateRequestModel body);
  Future<void> updateODO(int carID, int odo);
  Future<void> delete(int carID);
}

class CarsDataProvider implements ICarsDataProvider {
  final Client _httpClient;

  CarsDataProvider({required Client httpClient}) : _httpClient = httpClient;

  @override
  Future<List<CarModel>> getMyCars() async {
    final api = _httpClient.get(Uri(path: '/api/cars'));
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => CarModel.fromJson(e)).toList();
  }

  @override
  Future<CarModel?> create(CarCreateRequestModel body) async {
    final api = _httpClient.post(Uri(path: '/api/cars'), body: body);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      return null;
    }
    return CarModel.fromJson(json);
  }

  @override
  Future<void> update(CarUpdateRequestModel body) async {
    await _httpClient.put(Uri(path: '/api/cars/${body.carID}'), body: body);
  }

  @override
  Future<void> updateODO(int carID, int odo) async {
    await _httpClient.put(Uri(path: '/api/cars/$carID/update_odo'), body: {'odo': odo});
  }

  @override
  Future<void> delete(int carID) async {
    await _httpClient.delete(Uri(path: '/api/cars/$carID'));
  }
}
