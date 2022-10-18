import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/create/models/service_create_dto.dart';

class ServiceCreateCubit extends Cubit<AppState> {
  ServiceCreateCubit() : super(AppStateDefault());

  void create(QueryDocumentSnapshot groupDoc, ServiceCreateDTO body) {
    emit(AppStateLoading());

    groupDoc.reference.collection('groups').add(body.toJson()).then((_) {
      emit(AppStateSuccess());
      return null;
    }).catchError((e) {
      emit(AppStateError(
        'car_create_error',
        'Произошла ошибка при создании авто :(',
        details: e.toString(),
      ));
    });
  }
}
