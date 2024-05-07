import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/services_provider.dart';

abstract interface class IServicesRepository {
  Future<List<ServiceModel>> getByCarAndGroup(int carID, int groupID);
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
}
