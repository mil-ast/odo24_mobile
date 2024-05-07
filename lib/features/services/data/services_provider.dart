import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';

abstract interface class IServicesDataProvider {
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID);
}

class ServicesDataProvider implements IServicesDataProvider {
  final Dio _httpClient;

  ServicesDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID) async {
    final api = _httpClient.get('/api/cars/$carID/groups/$groupID/services');
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => ServiceModel.fromJson(e)).toList();
  }
}
