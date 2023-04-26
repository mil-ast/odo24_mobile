import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/groups/groups_service.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class CarScreenCubit extends Cubit<AppState> {
  final List<GroupModel> _groups = [];
  int _selectedIndex = -1;
  final _service = GroupsService();

  CarScreenCubit() : super(AppStateDefault());

  void getAllGroups() async {
    emit(AppStateLoading());

    final groups = await _service.getAll();
    groups.sort((a, b) => a.sort - b.sort);

    _groups.addAll(groups);

    GroupModel? selected;
    if (groups.isNotEmpty) {
      _selectedIndex = 0;
      selected = groups.first;
    }

    emit(GroupsState(_groups, selected));
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
