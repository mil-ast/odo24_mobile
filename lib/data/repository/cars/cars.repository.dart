import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/repository/cars/models/car_create_dto.dart';
import 'package:odo24_mobile/data/repository/cars/models/car_result_dto.dart';
import 'package:odo24_mobile/data/repository/cars/models/car_update_dto.dart';

class CarsRepository {
  final _api = HttpAPI.newDio();

  Future<List<CarDTO>> getAll() async {
    final api = _api.get('/api/cars');

    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => CarDTO.fromJson(e)).toList();
  }

  Future<CarDTO> create(CarCreateDTO car) async {
    final api = _api.post('/api/cars', data: car);

    final json = await ResponseHandler.parseJSON(api);
    return CarDTO.fromJson(json);
  }

  Future<void> update(CarUpdateDTO car) async {
    await _api.put('/api/cars/${car.carID}', data: car);
  }

  Future<void> delete(int carID) async {
    await _api.delete('/api/cars/$carID');
  }
}
