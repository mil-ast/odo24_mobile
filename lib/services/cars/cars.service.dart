import 'package:odo24_mobile/repository/cars/cars.repository.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarsService {
  final _repository = CarsRepository();

  Future<List<CarModel>> getAll() async {
    final result = await _repository.getAll();

    return result.map((dto) => CarModel.fromDTO(dto)).toList();
  }
}
