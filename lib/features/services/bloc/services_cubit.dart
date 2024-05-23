import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_states.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';

class ServicesCubit extends Cubit<ServicesState> {
  static const _maxMilleageForAutoUpdateODO = 10000;

  final IServicesRepository _servicesRepository;
  final ICarsRepository _carsRepository;
  final CarModel _selectedCar;
  final List<ServiceModel> _services = [];

  ServicesCubit({
    required CarModel selectedCar,
    required IServicesRepository servicesRepository,
    required ICarsRepository carsRepository,
  })  : _servicesRepository = servicesRepository,
        _carsRepository = carsRepository,
        _selectedCar = selectedCar,
        super(ServicesState.ready());

  Future<void> onChangeSelectedGroup(GroupModel selectedGroup) async {
    try {
      emit(ServicesState.idle());

      final services = await _servicesRepository.getByCarAndGroup(_selectedCar.carID, selectedGroup.groupID);
      _services.clear();
      _services.addAll(services);
      _refreshAndEmitServices();
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  }

  void _refreshAndEmitServices() {
    _services.sort(
      (a, b) {
        if (a.odo != null && b.odo != null) {
          return b.odo! - a.odo!;
        }
        return 0;
      },
    );

    for (int i = 0; i < _services.length; i++) {
      if (i != _services.length - 1) {
        final currModel = _services.elementAt(i);
        final prevModel = _services.elementAt(i + 1);
        if (prevModel.odo != null && currModel.odo != null) {
          final distance = currModel.odo! - prevModel.odo!;
          if (distance > 0) {
            currModel.leftDistance = distance;
          }
        }
      }
    }

    final nextOdoInform = _calcNextODOInformation();
    emit(ServicesState.showList(_services, nextOdoInform));
  }

  NextODOInformation? _calcNextODOInformation() {
    if (_services.isEmpty) {
      return null;
    }
    final lastService = _services.first;
    if (lastService.odo == null || lastService.nextDistance == null) {
      return null;
    }

    final nextOdo = lastService.odo! + lastService.nextDistance!;

    int leftDistance = nextOdo - _selectedCar.odo;
    if (leftDistance < 0) {
      leftDistance = 0;
    }

    NextODOInformationLevel level;
    if (leftDistance <= NextODOInformationLevel.warn.distance) {
      level = NextODOInformationLevel.alarm;
    } else if (leftDistance <= NextODOInformationLevel.normal.distance) {
      level = NextODOInformationLevel.warn;
    } else {
      level = NextODOInformationLevel.normal;
    }

    return NextODOInformation(leftDistance, level);
  }

  void openFormCreateService() {
    emit(ServicesState.actionCreate());
  }

  void openFormUpdateService(ServiceModel service) {
    emit(ServicesState.actionUpdate(service));
  }

  void onClickDeleteService(ServiceModel service) {
    emit(ServicesState.actionDelete(service));
  }

  Future<void> create(CarModel car, int groupID, ServiceCreateRequestModel body, {bool isConfirmed = false}) async {
    try {
      final milleage = (body.odo ?? 0) - car.odo;

      if (milleage > _maxMilleageForAutoUpdateODO) {
        // confirm
        return;
      }

      final model = await _servicesRepository.create(car.carID, groupID, body);
      _services.insert(0, model);
      emit(ServicesState.createSuccess());
      emit(ServicesState.message('Новая запись успешно добавлена!'));
      _refreshAndEmitServices();

      if (body.odo != null && milleage < _maxMilleageForAutoUpdateODO && body.odo! > car.odo) {
        // обновить пробег авто
        _carsRepository.updateODO(car.carID, body.odo!).then((v) {
          if (!isClosed) {
            emit(ServicesState.onCarODOAutoUpdate(body.odo!));
          }
        }).ignore();
      }
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  }

  Future<void> update(ServiceModel service, ServiceUpdateRequestModel body) async {
    try {
      await _servicesRepository.update(service.serviceID, body);

      final newService = service.copyWith(
        dt: DateTime.parse(body.dt),
        odo: body.odo,
        price: body.price,
        nextDistance: body.nextDistance,
        description: body.description,
      );

      final index = _services.indexWhere((s) => s.serviceID == newService.serviceID);
      _services.removeAt(index);
      _services.insert(index, newService);

      emit(ServicesState.updateSuccess());
      emit(ServicesState.message('Новая запись успешно добавлена!'));
      _refreshAndEmitServices();
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  }

  Future<void> delete(ServiceModel service) async {
    try {
      await _servicesRepository.delete(service);

      _services.remove(service);

      emit(ServicesState.deleteSuccess());
      emit(ServicesState.message('Запись успешно удалена!'));
      _refreshAndEmitServices();
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  }
}
