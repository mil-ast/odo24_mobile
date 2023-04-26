import 'package:odo24_mobile/repository/cars/car_result_dto.dart';

class CarModel {
  final int carID;
  String name;
  int odo;
  bool avatar;
  final int servicesTotal;

  CarModel({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
    required this.servicesTotal,
  });

  factory CarModel.fromDTO(CarDTO dto) {
    return CarModel(
      carID: dto.carID,
      name: dto.name,
      odo: dto.odo,
      avatar: dto.avatar,
      servicesTotal: dto.servicesTotal,
    );
  }
}
