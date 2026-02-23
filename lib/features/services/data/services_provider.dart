import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';

abstract interface class IServicesDataProvider {
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID);
  Future<ServiceModel?> create(int carID, int groupID, ServiceCreateRequestModel service);
  Future<void> update(int serviceID, ServiceUpdateRequestModel service);
  Future<void> delete(int serviceID);
}

class ServicesDataProvider implements IServicesDataProvider {
  final AppHttpClient _httpClient;

  ServicesDataProvider({required AppHttpClient httpClient}) : _httpClient = httpClient;

  @override
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID) async {
    final api = _httpClient.get(Uri(path: '/api/cars/$carID/groups/$groupID/services'));
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => ServiceModel.fromJson(e)).toList();
  }

  @override
  Future<ServiceModel?> create(int carID, int groupID, ServiceCreateRequestModel service) async {
    final api = _httpClient.post(Uri(path: '/api/cars/$carID/groups/$groupID/services'), body: service);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      return null;
    }
    return ServiceModel.fromJson(json);
  }

  @override
  Future<void> update(int serviceID, ServiceUpdateRequestModel service) async {
    await _httpClient.put(Uri(path: '/api/services/$serviceID'), body: service);
  }

  @override
  Future<void> delete(int serviceID) async {
    await _httpClient.delete(Uri(path: '/api/services/$serviceID'));
  }
}
