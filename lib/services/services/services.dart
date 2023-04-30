import 'package:odo24_mobile/repository/services/services_repository.dart';
import 'package:odo24_mobile/services/services/models/service_result_model.dart';

class Services {
  static final _instance = Services._internal();

  factory Services() {
    return _instance;
  }

  Services._internal();

  final _repository = ServicesRepository();

  Future<List<ServiceModel>> getByGroup(int carID, int groupID) async {
    final result = await _repository.getByGroup(carID, groupID);

    return result.map((dto) => ServiceModel.fromDTO(dto)).toList();
  }
/* 
  Future<CarModel> create(CarCreateDTO car) async {
    final result = await _repository.create(car);
    return CarModel.fromDTO(result);
  }

  Future<void> update(CarUpdateDTO car) {
    return _repository.update(car);
  }

  Future<void> delete(CarModel car) {
    return _repository.delete(car.carID);
  } */
}
