import 'package:odo24_mobile/data/repository/services/models/service_create_request_model.dart';
import 'package:odo24_mobile/data/repository/services/models/service_update_request_model.dart';
import 'package:odo24_mobile/data/repository/services/services_repository.dart';
import 'package:odo24_mobile/domain/services/services/models/service_result_model.dart';

class Services {
  static final _instance = Services._internal();

  factory Services() {
    return _instance;
  }

  Services._internal();

  final _repository = ServicesRepository();

  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID) async {
    final result = await _repository.getByGroup(carID, groupID);
    return result.map((dto) => ServiceModel.fromDTO(dto)).toList();
  }

  Future<ServiceModel> create(int carID, int groupID, ServiceCreateRequestModel service) async {
    final dto = await _repository.create(carID, groupID, service);
    return ServiceModel.fromDTO(dto);
  }

  Future<void> update(ServiceModel service, ServiceUpdateRequestModel body) {
    return _repository.update(service.serviceID, body);
  }

  Future<void> delete(ServiceModel service) {
    return _repository.delete(service.serviceID);
  }
/* 


  Future<void> update(CarUpdateDTO car) {
    return _repository.update(car);
  }

 */
}
