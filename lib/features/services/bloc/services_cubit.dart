import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';

part './services_states.dart';

class ServicesCubit extends Cubit<ServicesState> {
  static const _maxMilleageForAutoUpdateODO = 10000;

  final IServicesRepository _servicesRepository;
  final ICarsRepository _carsRepository;

  final CarModel selectedCar;
  final GroupModel selectedGroup;

  ServicesCubit({
    required IServicesRepository servicesRepository,
    required ICarsRepository carsRepository,
    required this.selectedCar,
    required this.selectedGroup,
  }) : _servicesRepository = servicesRepository,
       _carsRepository = carsRepository,
       super(const ServicesLoadingState());

  Future<void> getAllServices() async {
    try {
      final services = await _servicesRepository.getByCarAndGroup(selectedCar.carID, selectedGroup.groupID);
      _prepareServices(services: services);
      final nextOdoInform = _calcNextODOInformation(services: services, selectedCar: selectedCar);

      emit(ServicesShowListState(services: services, inform: nextOdoInform));
    } catch (e, st) {
      super.onError(e, st);
      emit(ServicesFailureState(e));
    }
  }

  void openFormCreateService() {
    emit(const ServicesActionShowCreateDialogState());
  }

  Future<void> create(ServiceCreateRequestModel body, {bool confirmed = false}) async {
    try {
      final newODO = (body.odo ?? 0);
      final milleage = (newODO - selectedCar.odo).abs();
      if (milleage > _maxMilleageForAutoUpdateODO && !confirmed) {
        // добавить подтверждение
        emit(ServiceCarODOConfirmState(body: body, milleage: milleage));
        return;
      }

      await _servicesRepository.create(selectedCar.carID, selectedGroup.groupID, body);

      if (milleage > 0 && (milleage < _maxMilleageForAutoUpdateODO || confirmed) && newODO > selectedCar.odo) {
        // обновить пробег авто
        try {
          await _carsRepository.updateODO(selectedCar.carID, newODO);
        } catch (e, st) {
          super.onError(e, st);
          debugPrint(e.toString());
        }
      }

      getAllServices();
      emit(const ServicesCreateSuccessState());
    } catch (e, st) {
      super.onError(e, st);
      emit(ServicesFailureState(e));
    }
  }

  Future<void> update({required int serviceID, required ServiceUpdateRequestModel body}) async {
    try {
      await _servicesRepository.update(serviceID, body);
      getAllServices();
      emit(const ServicesUpdateSuccessState());
    } catch (e, st) {
      super.onError(e, st);
      emit(ServicesFailureState(e));
    }
  }

  Future<void> delete(ServiceModel service) async {
    try {
      await _servicesRepository.delete(service);
      getAllServices();
      emit(const ServicesUpdateDeleteState());
    } catch (e, st) {
      super.onError(e, st);
      emit(ServicesFailureState(e));
    }
  }

  void showUpdateDialog(ServiceModel service) {
    emit(ServicesActionShowUpdateDialogState(service));
  }

  void confirmDeleteService(ServiceModel service) {
    emit(ServicesActionShowDeleteConfirmationDialogState(service));
  }

  void _prepareServices({required List<ServiceModel> services}) {
    services.sort();

    for (int i = 0; i < services.length - 1; i++) {
      final currModel = services.elementAt(i);
      final prevModel = services.elementAt(i + 1);
      if (prevModel.odo != null && currModel.odo != null) {
        final distance = currModel.odo! - prevModel.odo!;
        if (distance > 0) {
          currModel.leftDistance = distance;
        }
      }
    }
  }

  NextODOInformation? _calcNextODOInformation({required List<ServiceModel> services, required CarModel selectedCar}) {
    if (services.isEmpty) {
      return null;
    }
    final lastService = services.first;
    if (lastService.odo == null ||
        lastService.nextDistance == null ||
        lastService.odo == 0 ||
        lastService.nextDistance == 0) {
      return null;
    }

    final nextOdo = lastService.odo! + lastService.nextDistance!;

    int leftDistance = nextOdo - selectedCar.odo;
    if (leftDistance < 0) {
      leftDistance = 0;
    }

    double factor = 0;

    final mileageFromStart = selectedCar.odo - lastService.odo!;

    factor = mileageFromStart / lastService.nextDistance!;

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

    return NextODOInformation(leftDistance, factor, colorLevel);
  }

  /* void openFormCreateService() {
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
        // добавить подтверждение
        return;
      }

      if (body.odo != null && milleage < _maxMilleageForAutoUpdateODO && body.odo! > car.odo) {
        // обновить пробег авто
        try {
          await _carsRepository.updateODO(car.carID, body.odo!);
          emit(ServicesState.onCarODOAutoUpdate(body.odo!));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          //Sentry.captureException(e, stackTrace: StackTrace.current).ignore();
        }
      }

      final model = await _servicesRepository.create(car.carID, groupID, body);
      emit(ServicesState.createSuccess());
      emit(ServicesState.message('Новая запись успешно добавлена!'));
      //_refreshAndEmitServices();
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
      //_refreshAndEmitServices();
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  }

  Future<void> delete(ServiceModel service) async {
    try {
      await _servicesRepository.delete(service);

      //_services.remove(service);

      emit(ServicesState.deleteSuccess());
      emit(ServicesState.message('Запись успешно удалена!'));
      //_refreshAndEmitServices();
    } catch (e) {
      emit(ServicesState.failure(e));
    }
  } */
}
