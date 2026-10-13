import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';

class NextODOInformation {
  final double factor;
  final int leftDistance;
  final NextODOInformationColorLevel colorLevel;

  const NextODOInformation(this.leftDistance, this.factor, this.colorLevel);

  String toStringLeftDistancePercent() {
    return '${(factor * 100).round()}%';
  }
}

/// Общая логика расчёта остатка до следующего ТО.
///
/// [carODO] — текущий пробег автомобиля.
/// [serviceODO] — пробег на момент последнего ТО.
/// [nextDistance] — интервал до следующего ТО (`nextDistance`).
NextODOInformation calculateNextODOInformation({
  required int carODO,
  required int serviceODO,
  required int nextDistance,
}) {
  final nextOdo = serviceODO + nextDistance;

  int leftDistance = nextOdo - carODO;
  if (leftDistance < 0) {
    leftDistance = 0;
  }

  var factor = (carODO - serviceODO) / nextDistance;
  if (factor > 1) {
    factor = 1;
  } else if (factor < 0) {
    factor = 0;
  }

  NextODOInformationColorLevel colorLevel;
  final remainingFactor = 1 - factor;
  if (remainingFactor <= NextODOInformationColorLevel.alarm.factor) {
    colorLevel = NextODOInformationColorLevel.alarm;
  } else if (remainingFactor <= NextODOInformationColorLevel.warn.factor) {
    colorLevel = NextODOInformationColorLevel.warn;
  } else {
    colorLevel = NextODOInformationColorLevel.normal;
  }

  return NextODOInformation(leftDistance, factor, colorLevel);
}