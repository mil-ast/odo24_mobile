import 'dart:math';

class CarModel implements Comparable<CarModel> {
  static const _maxExtDataLength = 5;

  final int carID;
  final String name;
  final int odo;
  final bool avatar;
  final int servicesTotal;
  final List<CarExtraDataModel> carExtraDataModel;

  const CarModel({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
    required this.servicesTotal,
    required this.carExtraDataModel,
  });

  CarModel copyWith({required int newOdo}) => CarModel(
    carID: carID,
    name: name,
    odo: newOdo,
    avatar: avatar,
    servicesTotal: servicesTotal,
    carExtraDataModel: carExtraDataModel,
  );

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    carID: json['car_id'] as int,
    name: json['name'] as String,
    odo: json['odo'] as int,
    avatar: json['avatar'] as bool,
    servicesTotal: json['services_total'] as int,
    carExtraDataModel:
        json['car_ext_data'] == null
              ? []
              : _cutCarExtDataList(
                  (json['car_ext_data'] as List<dynamic>).cast<Map<String, dynamic>>(),
                ).map((e) => CarExtraDataModel.fromJson(e)).toList()
          ..sort(),
  );

  static List<Map<String, dynamic>> _cutCarExtDataList(List<Map<String, dynamic>> list) {
    return list.sublist(0, [list.length, _maxExtDataLength].reduce(min));
  }

  @override
  int compareTo(CarModel other) => carID - other.carID;
}

class CarExtraDataModel implements Comparable<CarExtraDataModel> {
  final int odo;
  final int leftOdo;
  final String groupName;

  const CarExtraDataModel({required this.odo, required this.leftOdo, required this.groupName});

  factory CarExtraDataModel.fromJson(Map<String, dynamic> json) => CarExtraDataModel(
    odo: json['service_odo'] as int,
    leftOdo: json['left_odo'] as int,
    groupName: json['group_name'] as String,
  );

  //NextODOInformation calculateLeftODO(int carODO) {
  //  return calculateNextODOInformation(carODO: carODO, serviceODO: odo, nextDistance: leftOdo);
  //}

  @override
  int compareTo(CarExtraDataModel other) => (odo + leftOdo) - (other.odo + other.leftOdo);
}
