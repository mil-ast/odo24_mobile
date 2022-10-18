import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/update/models/service_update_dto.dart';

class ServiceUpdateCubit extends Cubit<AppState> {
  ServiceUpdateCubit() : super(AppStateDefault());

  void update(QueryDocumentSnapshot serviceDoc, ServiceUpdateDTO body) {
    emit(AppStateLoading());

    serviceDoc.reference.update(body.toJson()).then((value) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'car_create_error',
        'Произошла ошибка при создании авто :(',
        details: e.toString(),
      ));
    });
  }
}
