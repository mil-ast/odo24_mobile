import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/services/service_model.dart';
import 'package:odo24_mobile/domain/services/services_service.dart';

class ServiceCreateCubit extends Cubit<AppState> {
  final ServicesService _serviceService = ServicesService();

  ServiceCreateCubit() : super(AppStateDefault());

  /*void create(ServiceModel service) {
    emit(AppStateLoading());

    _serviceService.create(service).then((_) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'car_create_error',
        'Произошла ошибка при создании авто :(',
        details: e.toString(),
      ));
    });
  }*/
}
