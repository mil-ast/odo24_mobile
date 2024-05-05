import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_states.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_update_request_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/repository/groups_repository.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final List<GroupModel> _groups = [];
  int _selectedIndex = -1;
  final IGroupsRepository _groupsRepository;

  GroupsCubit({
    required IGroupsRepository groupsRepository,
  })  : _groupsRepository = groupsRepository,
        super(GroupsState.idle());

  GroupModel? getSelected() {
    if (_selectedIndex == -1) {
      return null;
    }
    return _groups.elementAt(_selectedIndex);
  }

  List<GroupModel> get groups => _groups;

  void getAllGroups() async {
    emit(GroupsState.idle());

    try {
      final groups = await _groupsRepository.getAll();
      groups.sort((a, b) => a.sort - b.sort);

      _groups.clear();
      _groups.addAll(groups);

      GroupModel? selected;
      if (groups.isNotEmpty) {
        if (_selectedIndex > -1 && groups.length >= _selectedIndex + 1) {
          selected = groups.elementAt(_selectedIndex);
        } else {
          _selectedIndex = 0;
          selected = groups.first;
        }
      }

      emit(GroupsState.showGroups(_groups, selected: selected));
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void create(GroupCreateRequestModel body) async {
    try {
      final group = await _groupsRepository.create(body);

      _groups.add(group);
      emit(GroupsState.createSuccess(group));
      emit(GroupsState.message('Группа успешно добавлена!'));
      _selectedIndex = _groups.length - 1;
      refresh();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void update(GroupModel newGroup) async {
    try {
      final body = GroupUpdateRequestModel(
        groupID: newGroup.groupID,
        name: newGroup.name,
      );
      await _groupsRepository.update(body);

      final index = _groups.indexWhere((g) => g.groupID == newGroup.groupID);
      _groups.removeAt(index);
      _groups.insert(index, newGroup);

      emit(GroupsState.updateSuccess());
      emit(GroupsState.message('Изменения успешно сохранены!'));
      refresh();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void delete(GroupModel body) async {
    try {
      await _groupsRepository.delete(body.groupID);

      if (_groups.length > 1) {
        _groups.removeWhere((g) => g.groupID == body.groupID);
        if (_selectedIndex > _groups.length - 1) {
          _selectedIndex = _groups.length - 1;
        }
      } else {
        _selectedIndex = -1;
      }

      emit(GroupsState.deleteSuccess());
      emit(GroupsState.message('Группа "${body.name}" успешно удалена!'));

      refresh();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void onChangeGroup(GroupModel? group) {
    if (group == null) {
      return;
    }
    _selectedIndex = _groups.indexOf(group);
    refresh();
  }

  void updateSortGroups(List<GroupModel> groups, int changedIndex) async {
    try {
      final groupIDS = groups.map((e) => e.groupID).toList();
      await _groupsRepository.updateSortGroups(groupIDS);
      emit(GroupsState.resortSuccess());
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void onClickOpenGroupsSettingsScreen() {
    emit(GroupsState.action(GroupAction.openSettings));
  }

  void onClickCreateGroup() {
    emit(GroupsState.action(GroupAction.create));
  }

  void onClickUpdateGroup(GroupModel group) {
    emit(GroupsState.action(GroupAction.update, group: group));
  }

  void onClickDeleteGroup(GroupModel group) {
    emit(GroupsState.action(GroupAction.delete, group: group));
  }

  void refresh() {
    emit(GroupsState.showGroups(_groups, selected: _groups[_selectedIndex]));
  }

  void showMessage(String message) {
    emit(GroupsState.message(message));
  }
}
