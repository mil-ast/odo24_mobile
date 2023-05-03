import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/services/models/service_create_request_model.dart';
import 'package:odo24_mobile/repository/services/models/service_result_dto.dart';

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

  Future<ServiceDTO> create(int carID, int groupID, ServiceCreateRequestModel service) async {
    final result = await _api.post('/api/cars/$carID/groups/$groupID/services', data: service);
    final Map<String, dynamic> json = ResponseHandler.parse(result);
    return ServiceDTO.fromJson(json);
  }
}
