import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/car/create/models/car_create_dto.dart';

class CarCreateCubit extends Cubit<AppState> {
  CarCreateCubit() : super(AppStateDefault());

  Future<void> create(CarCreateDTO body) {
    emit(AppStateLoading());

    return FirebaseFirestore.instance.collection('cars').add(body.toJson()).then((_) {
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
