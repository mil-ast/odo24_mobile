import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/domain/services/groups/groups_service.dart';
import 'package:odo24_mobile/domain/services/groups/models/group.model.dart';

class GroupsSettingsCubit extends Cubit<AppState> {
  final GroupsCubit carCubit;
  final _service = GroupsService();

  GroupsSettingsCubit(this.carCubit) : super(AppStateDefault());

  void updateSortGroups(List<GroupModel> groups, int start) async {
    try {
      final groupIDS = groups.map((e) => e.groupID).toList();
      await _service.updateSortGroups(groupIDS);
      carCubit.updateSortGroups(groups, start);
      emit(GroupsSettingsSuccessState());
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void onClickCreateGroup() {
    emit(GroupsSettingsShowCreateGroupState());
  }

  void onClickEditGroup(GroupModel group) {
    emit(GroupsSettingsShowEditGroupState(group));
  }

  void onClickDeleteGroup(GroupModel group) {
    emit(GroupsSettingsDeleteGroupConfirmationState(group));
  }

  void delete(GroupModel group) async {
    try {
      await _service.delete(group.groupID);
      emit(GroupsDeleteSuccessState(group));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}

class GroupsSettingsBuildState implements AppState {}

class GroupsSettingsListenState implements AppState {}

class GroupsSettingsSuccessState implements GroupsSettingsListenState {}

class GroupsDeleteSuccessState implements GroupsSettingsListenState {
  final GroupModel group;
  GroupsDeleteSuccessState(this.group);
}

class GroupsSettingsShowCreateGroupState implements GroupsSettingsListenState {}

class GroupsSettingsShowEditGroupState implements GroupsSettingsListenState {
  final GroupModel group;
  GroupsSettingsShowEditGroupState(this.group);
}

class GroupsSettingsDeleteGroupConfirmationState implements GroupsSettingsListenState {
  final GroupModel group;
  GroupsSettingsDeleteGroupConfirmationState(this.group);
}
