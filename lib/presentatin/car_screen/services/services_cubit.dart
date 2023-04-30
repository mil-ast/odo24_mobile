import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';
import 'package:odo24_mobile/services/services/models/service_result_model.dart';
import 'package:odo24_mobile/services/services/services.dart';

class ServicesCubit extends Cubit<AppState> {
  final CarModel car;
  final GroupModel group;
  final List<ServiceModel> _services = [];
  final _service = Services();

  ServicesCubit(this.car, this.group) : super(AppStateDefault());

  void getByGroupID() async {
    emit(AppStateLoading());

    final result = await _service.getByGroup(car.carID, group.groupID);

    _services.addAll(result);

    refresh();
  }

  void refresh() {
    emit(ServicesState(_services));
  }
}

class BuildServiceState implements AppState {}

class ServicesState implements BuildServiceState {
  final List<ServiceModel> services;

  const ServicesState(this.services);
}
