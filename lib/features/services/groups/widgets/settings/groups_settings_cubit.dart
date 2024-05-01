/* import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/groups/data/repository/groups_repository.dart';
import 'package:odo24_mobile/features/services/groups/widgets/settings/groups_settings_state.dart';

class GroupsSettingsCubit extends Cubit<GroupSettingsState> {
  final IGroupsRepository _groupsRepository;

  GroupsSettingsCubit({required IGroupsRepository groupsRepository})
      : _groupsRepository = groupsRepository,
        super(GroupSettingsState.ready());

  void create(GroupCreateRequestModel body) async {
    try {
      final group = await _groupsRepository.create(body);

      _groups.add(group);
      emit(GroupsState.createSuccess(group));
      _selectedIndex = _groups.length - 1;
      refresh();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void update(GroupUpdateRequestModel body) async {
    try {
      await _groupsRepository.update(body);
      emit(GroupsState.updateSuccess());
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }
} */








/* import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/services/groups/groups_service.dart';
import 'package:odo24_mobile/domain/services/groups/models/group.model.dart';

class GroupsSettingsCubit extends Cubit<AppState> {
  final _service = GroupsService();

  GroupsSettingsCubit() : super(AppStateDefault());

  void updateSortGroups(List<GroupModel> groups, int start) async {
    try {
      final groupIDS = groups.map((e) => e.groupID).toList();
      await _service.updateSortGroups(groupIDS);
      emit(GroupsSettingsSuccessState(
        groups: groups,
        start: start,
      ));
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

class GroupsSettingsSuccessState implements GroupsSettingsListenState {
  final List<GroupModel> groups;
  final int start;

  GroupsSettingsSuccessState({
    required this.groups,
    required this.start,
  });
}

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
 */