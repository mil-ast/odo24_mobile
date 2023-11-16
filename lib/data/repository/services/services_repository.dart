import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/repository/services/models/service_create_request_model.dart';
import 'package:odo24_mobile/data/repository/services/models/service_result_dto.dart';
import 'package:odo24_mobile/data/repository/services/models/service_update_request_model.dart';

class ServicesRepository {
  final _api = HttpAPI.newDio();

  Future<List<ServiceDTO>> getByGroup(int carID, int groupID) async {
    final api = _api.get('/api/cars/$carID/groups/$groupID/services');

    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => ServiceDTO.fromJson(e)).toList();
  }

  Future<ServiceDTO> create(int carID, int groupID, ServiceCreateRequestModel service) async {
    final api = _api.post('/api/cars/$carID/groups/$groupID/services', data: service);
    final json = await ResponseHandler.parseJSON(api);
    return ServiceDTO.fromJson(json);
  }

  Future<void> update(int serviceID, ServiceUpdateRequestModel service) async {
    await _api.put('/api/services/$serviceID', data: service);
  }

  Future<void> delete(int serviceID) async {
    await _api.delete('/api/services/$serviceID');
  }
}
