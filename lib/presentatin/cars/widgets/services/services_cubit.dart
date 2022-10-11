import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/services/services_service.dart';

class ServicesCubit extends Cubit<AppState> {
  final ServicesService _groupsService = ServicesService();

  ServicesCubit() : super(AppStateDefault());

  /*void create(String groupName) {
    emit(AppStateLoading());

    _groupsService.create(groupName).then((_) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'group_create_error',
        'Произошла ошибка при создании группы :(',
        details: e.toString(),
      ));
    });
  }*/
}
