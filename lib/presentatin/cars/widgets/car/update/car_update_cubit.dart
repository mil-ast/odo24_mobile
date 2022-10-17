import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/car/update/models/car_update_dto.dart';

class CarUpdateCubit extends Cubit<AppState> {
  CarUpdateCubit() : super(AppStateDefault());

  Future<void> update(QueryDocumentSnapshot carDoc, CarUpdateDTO body) {
    emit(AppStateLoading());

    return carDoc.reference.set(body.toJson()).then((_) {
      emit(AppStateSuccess());
      return null;
    }).catchError((e) {
      emit(AppStateError(
        'car_update_error',
        'Произошла ошибка при изменении авто :(',
        details: e.toString(),
      ));
    });
  }
}
