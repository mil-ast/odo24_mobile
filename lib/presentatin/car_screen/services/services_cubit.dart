import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/data/repository/services/models/service_create_request_model.dart';
import 'package:odo24_mobile/data/repository/services/models/service_update_request_model.dart';
import 'package:odo24_mobile/domain/services/cars/models/car.model.dart';
import 'package:odo24_mobile/domain/services/services/models/service_result_model.dart';
import 'package:odo24_mobile/domain/services/services/services.dart';

class ServicesCubit extends Cubit<AppState> {
  final CarModel car;

  final List<ServiceModel> _services = [];
  final _service = Services();

  ServicesCubit(this.car) : super(AppStateDefault());

  void getByGroupID(int groupID) async {
    emit(AppStateLoading());

    final result = await _service.getByCarAndGroup(car.carID, groupID);

    _services.clear();
    _services.addAll(result);

    if (!isClosed) {
      //_sortServicesByOdo();
      refresh();
    }
  }

  void create(CarModel car, int groupID, ServiceCreateRequestModel body) async {
    try {
      final service = await _service.create(car.carID, groupID, body);

      _services.add(service);

      emit(ServiceCreateSuccessful(service));

      car.servicesTotal++;

      //_sortServicesByOdo();
      refresh();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void update(ServiceModel service, ServiceUpdateRequestModel body) async {
    try {
      await _service.update(service, body);

      service.odo = body.odo;
      service.nextDistance = body.nextDistance;
      service.dt = DateTime.parse(body.dt);
      service.price = body.price;

      emit(ServiceUpdateSuccessful());

      //_sortServicesByOdo();
      refresh();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void delete(CarModel car, ServiceModel service) async {
    try {
      await _service.delete(service);

      _services.remove(service);
      car.servicesTotal--;

      refresh();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void refresh() {
    emit(ServicesState(_services));
  }

  void onClickCreateServiceRec() {
    emit(ClickOpenDialogCreateServiceRec());
  }

  void onClickEditService(ServiceModel service) {
    emit(ClickUpdateServiceRec(service));
  }

  void onClickDeleteService(ServiceModel service) {
    emit(ClickConfirmationDeleteServiceRec(service));
  }

  void _sortServicesByOdo() {
    _services.sort((a, b) {
      if (a.odo != null && b.odo != null) {
        return b.odo! - a.odo!;
      }
      return 0;
    });
  }
}

class BuildServiceState implements AppState {}

class ListenServiceState implements AppState {}

class ServicesState implements BuildServiceState {
  final List<ServiceModel> services;

  const ServicesState(this.services);
}

class ServiceCreateSuccessful implements BuildServiceState {
  final ServiceModel service;

  const ServiceCreateSuccessful(this.service);
}

class ServiceUpdateSuccessful implements BuildServiceState {}

// listen

class ClickOpenDialogCreateServiceRec implements ListenServiceState {}

class ClickConfirmationDeleteServiceRec implements ListenServiceState {
  final ServiceModel service;
  const ClickConfirmationDeleteServiceRec(this.service);
}

class ClickUpdateServiceRec implements ListenServiceState {
  final ServiceModel service;
  const ClickUpdateServiceRec(this.service);
}
