import 'package:intl/intl.dart';
import 'package:odo24_mobile/data/repository/services/models/service_result_dto.dart';

class ServiceModel {
  final int serviceID;
  int? odo;
  int? nextDistance;
  int? leftDistance;
  DateTime dt;
  String? description;
  int? price;
  final _numberFormat = NumberFormat.decimalPattern();

  ServiceModel({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
    this.leftDistance,
    required this.dt,
    required this.description,
    required this.price,
  });

  String get formatDt {
    return DateFormat.yMMMMd().format(dt);
  }

  String? get formatOdo {
    if (odo == null) {
      return null;
    }
    return _numberFormat.format(odo);
  }

  String? get formatLeftOdo {
    if (leftDistance == null) {
      return null;
    }
    return _numberFormat.format(leftDistance);
  }

  String? get formatPrice {
    if (price == null) {
      return null;
    }
    return NumberFormat.currency(decimalDigits: 0, symbol: '₽').format(price);
  }

  factory ServiceModel.fromDTO(ServiceDTO dto) {
    return ServiceModel(
      serviceID: dto.serviceID,
      odo: dto.odo,
      nextDistance: dto.nextDistance,
      dt: DateTime.parse(dto.dt),
      description: dto.description,
      price: dto.price,
    );
  }
}
