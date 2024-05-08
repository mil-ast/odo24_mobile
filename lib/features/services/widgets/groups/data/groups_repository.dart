import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_update_request_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_data_provider.dart';

abstract interface class IGroupsRepository {
  Future<List<GroupModel>> getAll();
  Future<void> updateSortGroups(List<int> sortedGroupIDs);
  Future<void> update(GroupUpdateRequestModel group);
  Future<GroupModel> create(GroupCreateRequestModel group);
  Future<void> delete(int groupID);
}

class GroupsRepository implements IGroupsRepository {
  final GroupsDataProvider _groupsDataProvider;

  GroupsRepository({
    required GroupsDataProvider groupsDataProvider,
  }) : _groupsDataProvider = groupsDataProvider;

  @override
  Future<List<GroupModel>> getAll() {
    return _groupsDataProvider.getAll();
  }

  @override
  Future<void> updateSortGroups(List<int> sortedGroupIDs) async {
    await _groupsDataProvider.updateSortGroups(sortedGroupIDs);
  }

  @override
  Future<void> update(GroupUpdateRequestModel group) async {
    await _groupsDataProvider.update(group);
  }

  @override
  Future<GroupModel> create(GroupCreateRequestModel group) async {
    final result = await _groupsDataProvider.create(group);
    if (result == null) {
      throw Exception('Произошла ошибка при создании группы');
    }
    return result;
  }

  @override
  Future<void> delete(int groupID) async {
    await _groupsDataProvider.delete(groupID);
  }
}
