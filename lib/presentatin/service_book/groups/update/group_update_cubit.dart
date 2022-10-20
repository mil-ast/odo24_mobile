import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/constants/database_constants.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/update/models/group_update_dto.dart';

class GroupUpdateCubit extends Cubit<AppState> {
  GroupUpdateCubit() : super(AppStateDefault());

  void update(QueryDocumentSnapshot<Object?> groupDoc, GroupUpdateDTO body) {
    emit(AppStateLoading());

    groupDoc.reference.update(body.toJson()).then((_) {
      emit(AppStateSuccess());
      return null;
    }).catchError((e) {
      emit(AppStateError(
        'group_update_error',
        'Произошла ошибка при изменении группы :(',
        details: e.toString(),
      ));
    });
  }
}
