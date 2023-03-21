import 'package:odo24_mobile/repository/cars/auth_result.dto.dart';

class CarModel {
  final int carID;
  final String name;
  final int odo;
  final bool avatar;

  CarModel({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
  });

  factory CarModel.fromDTO(CarDTO dto) {
    return CarModel(
      carID: dto.carID,
      name: dto.name,
      odo: dto.odo,
      avatar: dto.avatar,
    );
  }
}
