import 'package:odo24_mobile/features/services/groups/data/models/group_model.dart';

enum GroupAction {
  openSettings,
  create,
  update,
  delete,
}

sealed class GroupsState {
  final bool needBuild;
  const GroupsState(this.needBuild);

  factory GroupsState.idle() = LoadingState;
  factory GroupsState.failure(Object err) = CarsErrorState;
  factory GroupsState.message(String message) = GroupsMessageState;
  factory GroupsState.showGroups(List<GroupModel> groups, {GroupModel? selected}) = ShowGroupsState;
  factory GroupsState.createSuccess(GroupModel newGroup) = GroupsCreateSuccessState;
  factory GroupsState.updateSuccess() = GroupsUpdateSuccessState;
  factory GroupsState.deleteSuccess() = GroupsDeleteSuccessState;
  factory GroupsState.resortSuccess() = GroupsResortSuccessState;
  factory GroupsState.action(GroupAction action, {GroupModel group}) = GroupsActionState;
}

class LoadingState extends GroupsState {
  const LoadingState() : super(true);
}

class ShowGroupsState extends GroupsState {
  final GroupModel? selected;
  final List<GroupModel> groups;

  ShowGroupsState(this.groups, {this.selected}) : super(true);
}

class CarsErrorState extends GroupsState {
  final String message;
  CarsErrorState(Object err)
      : message = err.toString(),
        super(false);
}

class GroupsCreateSuccessState extends GroupsState {
  final GroupModel newGroup;
  GroupsCreateSuccessState(this.newGroup) : super(false);
}

class GroupsUpdateSuccessState extends GroupsState {
  GroupsUpdateSuccessState() : super(false);
}

class GroupsDeleteSuccessState extends GroupsState {
  GroupsDeleteSuccessState() : super(false);
}

class GroupsResortSuccessState extends GroupsState {
  GroupsResortSuccessState() : super(true);
}

class GroupsActionState extends GroupsState {
  final GroupAction action;
  final GroupModel? group;
  GroupsActionState(this.action, {this.group}) : super(false);
}

class GroupsMessageState extends GroupsState {
  final String message;
  GroupsMessageState(this.message) : super(false);
}



/* abstract class BuildGroupsState extends AppState {}

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
 */