import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_update_request_model.dart';

abstract interface class IGroupsDataProvider {
  Future<List<GroupModel>> getAll();
  Future<void> updateSortGroups(List<int> sortedGroupIDs);
  Future<GroupModel?> create(GroupCreateRequestModel group);
  Future<void> update(GroupUpdateRequestModel group);
  Future<void> delete(int groupID);
}

class GroupsDataProvider implements IGroupsDataProvider {
  final Dio _httpClient;

  GroupsDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<GroupModel>> getAll() async {
    final api = _httpClient.get('/api/groups');
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateSortGroups(List<int> sortedGroupIDs) async {
    await _httpClient.post('/api/groups/update_sort', data: sortedGroupIDs);
  }

  @override
  Future<void> update(GroupUpdateRequestModel group) async {
    await _httpClient.put('/api/groups/${group.groupID}', data: group);
  }

  @override
  Future<GroupModel?> create(GroupCreateRequestModel group) async {
    final api = _httpClient.post('/api/groups', data: group);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      return null;
    }
    return GroupModel.fromJson(json);
  }

  @override
  Future<void> delete(int groupID) async {
    await _httpClient.delete('/api/groups/$groupID');
  }
}
