import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/constants/database_constants.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/create/models/car_create_dto.dart';

class CarCreateCubit extends Cubit<AppState> {
  CarCreateCubit() : super(AppStateDefault());

  void create(CarCreateDTO body) {
    emit(AppStateLoading());

    FirebaseFirestore.instance.collection(carsCollection).add(body.toJson()).then((_) {
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
