import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_states.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final IServicesRepository _servicesRepository;
  final CarModel _selectedCar;
  final List<ServiceModel> _services = [];

  ServicesCubit({
    required CarModel selectedCar,
    required IServicesRepository servicesRepository,
  })  : _servicesRepository = servicesRepository,
        _selectedCar = selectedCar,
        super(ServicesState.ready());

  Future<void> onChangeSelectedGroup(GroupModel selectedGroup) async {
    emit(ServicesState.idle());

    final services = await _servicesRepository.getByCarAndGroup(_selectedCar.carID, selectedGroup.groupID);
    _services.clear();
    _services.addAll(services);
    _refreshAndEmitServices();
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

    emit(ServicesState.showList(_services));
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

  Future<void> create(int carID, int groupID, ServiceCreateRequestModel body) async {
    final model = await _servicesRepository.create(carID, groupID, body);
    _services.insert(0, model);
    emit(ServicesState.createSuccess());
    emit(ServicesState.message('Новая запись успешно добавлена!'));
    _refreshAndEmitServices();
  }

  Future<void> update(ServiceModel service, ServiceUpdateRequestModel body) async {
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
  }

  Future<void> delete(ServiceModel service) async {
    await _servicesRepository.delete(service);

    _services.remove(service);

    emit(ServicesState.deleteSuccess());
    emit(ServicesState.message('Запись успешно удалена!'));
    _refreshAndEmitServices();
  }
}
