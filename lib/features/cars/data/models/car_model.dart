import 'dart:math';

import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/features/services/bloc/services_states.dart';

class CarModel implements Comparable<CarModel> {
  static const _maxExtDataLength = 3;

  final int carID;
  final String name;
  final int odo;
  final bool avatar;
  final int servicesTotal;
  final List<CarExtraDataModel> carExtraDataModel;

  CarModel({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
    required this.servicesTotal,
    required this.carExtraDataModel,
  });

  CarModel copyWith({
    required int newOdo,
  }) =>
      CarModel(
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
        carExtraDataModel: json['car_ext_data'] == null
            ? []
            : cutCarExtDataList((json['car_ext_data'] as List<dynamic>).cast<Map<String, dynamic>>())
                .map((e) => CarExtraDataModel.fromJson(e))
                .toList()
          ..sort(),
      );

  static List<Map<String, dynamic>> cutCarExtDataList(List<Map<String, dynamic>> list) {
    return list.sublist(0, [list.length, _maxExtDataLength].reduce(min));
  }

  @override
  int compareTo(CarModel other) => carID - other.carID;
}

class CarExtraDataModel implements Comparable<CarExtraDataModel> {
  final int odo;
  final int nextOdo;
  final String groupName;

  const CarExtraDataModel({
    required this.odo,
    required this.nextOdo,
    required this.groupName,
  });

  factory CarExtraDataModel.fromJson(Map<String, dynamic> json) => CarExtraDataModel(
        odo: json['odo'] as int,
        nextOdo: json['next_odo'] as int,
        groupName: json['group_name'] as String,
      );

  NextODOInformation calculateLeftODO(int carODO) {
    double factor = 0;
    final nextMileage = odo + nextOdo;
    final mileageFromStart = carODO - odo;

    factor = mileageFromStart / nextOdo;

    if (factor > 1) {
      factor = 1;
    } else if (factor < 0) {
      factor = 0;
    }

    NextODOInformationColorLevel colorLevel;
    final rFactor = 1 - factor;
    if (rFactor <= NextODOInformationColorLevel.alarm.factor) {
      colorLevel = NextODOInformationColorLevel.alarm;
    } else if (rFactor <= NextODOInformationColorLevel.warn.factor) {
      colorLevel = NextODOInformationColorLevel.warn;
    } else {
      colorLevel = NextODOInformationColorLevel.normal;
    }

    int leftDistance = nextMileage - carODO;
    if (leftDistance < 0) {
      leftDistance = 0;
    }

    return NextODOInformation(leftDistance, factor, colorLevel);
  }

  @override
  int compareTo(CarExtraDataModel other) => (odo + nextOdo) - (other.odo + other.nextOdo);
}
