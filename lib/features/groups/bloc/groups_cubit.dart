import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/groups/data/groups_repository.dart';
import 'package:odo24_mobile/features/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_update_request_model.dart';
part 'groups_states.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final IGroupsRepository _groupsRepository;

  GroupsCubit({required IGroupsRepository groupsRepository})
    : _groupsRepository = groupsRepository,
      super(GroupsState.waiting());

  Future<void> getAllGroups() async {
    try {
      final groups = await _groupsRepository.getAll();
      emit(GroupsState.loaded(groups));
    } catch (e, st) {
      super.onError(e, st);
      emit(GroupsState.failure(e));
    }
  }

  void onSelectGroup(GroupModel group) {
    emit(GroupsOnSelectState(group));
  }

  void create(GroupCreateRequestModel body) async {
    try {
      await _groupsRepository.create(body);
      emit(GroupsState.createSuccess());
      await getAllGroups();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void update(GroupUpdateRequestModel body) async {
    try {
      await _groupsRepository.update(body);

      emit(GroupsState.updateSuccess());
      await getAllGroups();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void showUpdateDialog(GroupModel group) {
    emit(GroupsActionShowUpdateDialogState(group));
  }

  void showDeleteConfirmDialog(GroupModel group) {
    emit(GroupsDeleteShowConfirmDialogState(group));
  }

  void delete(GroupModel body) async {
    try {
      await _groupsRepository.delete(body.groupID);

      emit(GroupsState.deleteSuccess());
      getAllGroups().ignore();
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void updateSortGroups(List<GroupModel> groups) async {
    try {
      final groupIDS = groups.map((e) => e.groupID).toList();
      await _groupsRepository.updateSortGroups(groupIDS);
      emit(GroupsState.updateSuccess());
    } catch (e) {
      emit(GroupsState.failure(e));
    }
  }

  void openFormCreateGroup() {
    emit(GroupsState.actionCreate());
  }
}
