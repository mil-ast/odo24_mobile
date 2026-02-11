part of 'groups_cubit.dart';

sealed class GroupsState {
  const GroupsState();

  factory GroupsState.waiting() = GroupsWaitingState;
  factory GroupsState.failure(Object err) = GroupsFailureState;
  factory GroupsState.loaded(List<GroupModel> groups) = GroupsLoadedState;
  factory GroupsState.actionCreate() = GroupsActionShowCreateDialogState;
  factory GroupsState.createSuccess() = GroupsCreateSuccessState;
  factory GroupsState.updateSuccess() = GroupsUpdateSuccessState;
  factory GroupsState.deleteSuccess() = GroupsDeleteSuccessState;

  bool get needBuild => switch (this) {
    GroupsWaitingState() => true,
    GroupsFailureState() => false,
    GroupsLoadedState() => true,
    GroupsEmptyGroupsState() => true,
    GroupsActionShowCreateDialogState() => false,
    GroupsOnSelectState() => false,
    GroupsCreateSuccessState() => false,
    GroupsUpdateSuccessState() => false,
    GroupsDeleteSuccessState() => false,
    GroupsActionShowUpdateDialogState() => false,
    GroupsDeleteShowConfirmDialogState() => false,
  };
}

class GroupsWaitingState extends GroupsState {
  const GroupsWaitingState();
}

class GroupsFailureState extends GroupsState {
  final String message;
  GroupsFailureState(Object err) : message = err.toString();
}

class GroupsLoadedState extends GroupsState {
  final List<GroupModel> groups;

  const GroupsLoadedState(this.groups);
}

class GroupsEmptyGroupsState extends GroupsState {
  const GroupsEmptyGroupsState();
}

class GroupsActionShowCreateDialogState extends GroupsState {
  const GroupsActionShowCreateDialogState();
}

class GroupsActionShowUpdateDialogState extends GroupsState {
  final GroupModel group;
  const GroupsActionShowUpdateDialogState(this.group);
}

class GroupsOnSelectState extends GroupsState {
  final GroupModel group;
  const GroupsOnSelectState(this.group);
}

class GroupsCreateSuccessState extends GroupsState {
  const GroupsCreateSuccessState();
}

class GroupsUpdateSuccessState extends GroupsState {
  const GroupsUpdateSuccessState();
}

class GroupsDeleteSuccessState extends GroupsState {
  const GroupsDeleteSuccessState();
}

class GroupsDeleteShowConfirmDialogState extends GroupsState {
  final GroupModel group;
  const GroupsDeleteShowConfirmDialogState(this.group);
}
