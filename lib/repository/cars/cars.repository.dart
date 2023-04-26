import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/cars/car_create_dto.dart';
import 'package:odo24_mobile/repository/cars/car_result_dto.dart';
import 'package:odo24_mobile/repository/cars/car_update_dto.dart';

class CarsRepository {
  final _api = HttpAPI.newDio();

  Future<List<CarDTO>> getAll() async {
    final result = await _api.get('/api/cars');

    final List<dynamic> json = ResponseHandler.parse(result);
    return json.map((e) => CarDTO.fromJson(e)).toList();
  }

  Future<CarDTO> create(CarCreateDTO car) async {
    final result = await _api.post('/api/cars', data: car);

    final Map<String, dynamic> json = ResponseHandler.parse(result);
    return CarDTO.fromJson(json);
  }

  Future<void> update(CarUpdateDTO car) {
    return _api.put('/api/cars/${car.carID}', data: car);
  }

  Future<void> delete(int carID) {
    return Future.value(null); // TODO
    return _api.delete('/api/cars/$carID');
  }
}
