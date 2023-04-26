import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/groups/group_create_request_model.dart';
import 'package:odo24_mobile/services/groups/groups_service.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class GroupCreateCubit extends Cubit<AppState> {
  final _service = GroupsService();

  GroupCreateCubit() : super(AppStateDefault());

  void create(GroupCreateRequestModel body) async {
    try {
      final group = await _service.create(body);
      emit(AppStateSuccess<GroupModel>(group));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}
