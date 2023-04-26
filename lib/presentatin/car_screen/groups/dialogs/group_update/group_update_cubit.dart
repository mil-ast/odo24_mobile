import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/groups/group_update_request_model.dart';
import 'package:odo24_mobile/services/groups/groups_service.dart';

class GroupUpdateCubit extends Cubit<AppState> {
  final _service = GroupsService();

  GroupUpdateCubit() : super(AppStateDefault());

  void update(GroupUpdateRequestModel body) async {
    try {
      await _service.update(body);
      emit(AppStateSuccess<GroupUpdateRequestModel>(body));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}
