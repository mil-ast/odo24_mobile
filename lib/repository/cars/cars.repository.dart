import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/cars/auth_result.dto.dart';

class CarsRepository {
  final _api = HttpAPI.newDio();

  Future<List<CarDTO>> getAll() async {
    final result = await _api.get('/api/cars');

    final List<dynamic> json = ResponseHandler.parse(result);
    return json.map((e) => CarDTO.fromJson(e)).toList();
  }
}
