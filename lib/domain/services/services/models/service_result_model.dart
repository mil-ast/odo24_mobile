import 'package:intl/intl.dart';
import 'package:odo24_mobile/data/repository/services/models/service_result_dto.dart';

class ServiceModel {
  final int serviceID;
  int? odo;
  int? nextDistance;
  DateTime dt;
  String? description;
  int? price;

  ServiceModel({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
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
    return NumberFormat.decimalPattern().format(odo);
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
