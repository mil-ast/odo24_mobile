import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';

class ServicesCubit extends Cubit<AppState> {
  ServicesCubit() : super(AppStateDefault());

  Stream<QuerySnapshot<Map<String, dynamic>>> getServicesByCar(
    QueryDocumentSnapshot<Object?> carDoc,
    QueryDocumentSnapshot<Object?> groupDoc,
  ) {
    return groupDoc.reference
        .collection('services')
        .where('car_ref', isEqualTo: carDoc.reference)
        .orderBy('dt', descending: true)
        .snapshots();
  }

  void onClickOpenCreatetDialog() {
    emit(AppStateServicesActionCreateState());
  }

  void onClickOpenEditDialog(QueryDocumentSnapshot<Map<String, dynamic>> service) {
    emit(AppStateServicesActionEditState(service));
  }

  void delete(QueryDocumentSnapshot<Map<String, dynamic>> service) {
    service.reference.delete().then((_) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'group_create_error',
        'Произошла ошибка при удалении сервиса :(',
        details: e.toString(),
      ));
    });
  }
}

class AppStateServicesActionState extends AppState {}

class AppStateServicesActionCreateState extends AppStateServicesActionState {}

class AppStateServicesActionEditState extends AppStateServicesActionState {
  final QueryDocumentSnapshot<Map<String, dynamic>> service;
  AppStateServicesActionEditState(this.service);
}
