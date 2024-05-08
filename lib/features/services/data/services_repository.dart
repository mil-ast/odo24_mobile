import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';
import 'package:odo24_mobile/features/services/data/services_provider.dart';

abstract interface class IServicesRepository {
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID);
  Future<ServiceModel> create(int carID, int groupID, ServiceCreateRequestModel service);
  Future<void> update(int serviceID, ServiceUpdateRequestModel service);
  Future<void> delete(ServiceModel service);
}

class ServicesRepository implements IServicesRepository {
  final IServicesDataProvider _servicesDataProvider;

  ServicesRepository({
    required IServicesDataProvider servicesDataProvider,
  }) : _servicesDataProvider = servicesDataProvider;

  @override
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID) {
    return _servicesDataProvider.getByCarAndGroup(carID, groupID);
  }

  @override
  Future<ServiceModel> create(int carID, int groupID, ServiceCreateRequestModel service) async {
    final result = await _servicesDataProvider.create(carID, groupID, service);
    if (result == null) {
      throw Exception('Произошла ошибка при создании записи');
    }
    return result;
  }

  @override
  Future<void> update(int serviceID, ServiceUpdateRequestModel service) async {
    await _servicesDataProvider.update(serviceID, service);
  }

  @override
  Future<void> delete(ServiceModel service) async {
    await _servicesDataProvider.delete(service.serviceID);
  }
}
