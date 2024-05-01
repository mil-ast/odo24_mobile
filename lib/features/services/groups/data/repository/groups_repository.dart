import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_update_request_model.dart';
import 'package:odo24_mobile/features/services/groups/data/providers/groups_data_provider.dart';

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
  Future<List<GroupModel>> getAll() async {
    final api = _groupsDataProvider.getAll();
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => GroupModel.fromJson(e)).toList();
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
    final api = _groupsDataProvider.create(group);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw Exception('Произошла ошибка при создании группы');
    }
    return GroupModel.fromJson(json);
  }

  @override
  Future<void> delete(int groupID) async {
    await _groupsDataProvider.delete(groupID);
  }
}
