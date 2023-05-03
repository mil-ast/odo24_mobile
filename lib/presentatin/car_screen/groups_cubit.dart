import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/repository/groups/models/group_create_request_model.dart';
import 'package:odo24_mobile/repository/groups/models/group_update_request_model.dart';
import 'package:odo24_mobile/services/groups/groups_service.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class GroupsCubit extends Cubit<AppState> {
  final List<GroupModel> _groups = [];
  int _selectedIndex = -1;
  final _service = GroupsService();

  GroupsCubit() : super(AppStateDefault());

  void getAllGroups() async {
    emit(AppStateLoading());

    try {
      final groups = await _service.getAll();
      groups.sort((a, b) => a.sort - b.sort);

      _groups.addAll(groups);

      GroupModel? selected;
      if (groups.isNotEmpty) {
        _selectedIndex = 0;
        selected = groups.first;
      }

      emit(GroupsState(_groups, selected));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void create(GroupCreateRequestModel body) async {
    try {
      final group = await _service.create(body);

      _groups.add(group);
      emit(GroupCreateSuccessful(group));
      _selectedIndex = _groups.length - 1;
      refresh();
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void update(GroupUpdateRequestModel body) async {
    try {
      await _service.update(body);
      emit(AppStateSuccess<GroupUpdateRequestModel>(body));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void onChangeGroup(GroupModel? group) {
    if (group == null) {
      return;
    }
    _selectedIndex = _groups.indexOf(group);

    emit(GroupsState(_groups, _groups[_selectedIndex]));
  }

  void updateSortGroups(List<GroupModel> groups, int changedIndex) {
    try {
      _selectedIndex = changedIndex;
      emit(GroupsState(_groups, _groups[_selectedIndex]));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void onClickOpenGroupsSettingsDialog() {
    emit(OpenGroupsSettingDialogState(_groups));
  }

  void refresh() {
    emit(GroupsState(_groups, _groups[_selectedIndex]));
  }
}

abstract class BuildGroupsState extends AppState {}

abstract class ListenGroupsState extends AppState {}

class GroupsState implements BuildGroupsState {
  final GroupModel? selected;
  final List<GroupModel> groups;
  const GroupsState(this.groups, this.selected);
}

class OpenGroupsSettingDialogState implements ListenGroupsState {
  final List<GroupModel> groups;
  const OpenGroupsSettingDialogState(this.groups);
}

class GroupCreateSuccessful implements ListenGroupsState {
  final GroupModel newGroup;
  const GroupCreateSuccessful(this.newGroup);
}
