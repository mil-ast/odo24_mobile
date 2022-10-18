import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/create/models/group_create_dto.dart';

class GroupCreateCubit extends Cubit<AppState> {
  GroupCreateCubit() : super(AppStateDefault());

  void create(GroupCreateDTO body) {
    emit(AppStateLoading());

    FirebaseFirestore.instance.collection('groups').add(body.toJson()).then((value) {
      emit(AppStateSuccess());
    }).catchError((e) {
      emit(AppStateError(
        'group_create_error',
        'Произошла ошибка при создании группы :(',
        details: e.toString(),
      ));
    });
  }
}
