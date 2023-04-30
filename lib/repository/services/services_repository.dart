import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/services/service_result_dto.dart';

class ServicesRepository {
  final _api = HttpAPI.newDio();

  Future<List<ServiceDTO>> getByGroup(int carID, int groupID) async {
    final result = await _api.get('/api/cars/$carID/groups/$groupID/services');

    final List<dynamic>? json = ResponseHandler.parse(result);
    if (json == null) {
      return [];
    }
    return json.map((e) => ServiceDTO.fromJson(e)).toList();
  }
}
