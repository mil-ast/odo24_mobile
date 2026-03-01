import 'package:http/http.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/features/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_update_request_model.dart';

abstract interface class IGroupsDataProvider {
  Future<List<GroupModel>> getAll();
  Future<void> updateSortGroups(List<int> sortedGroupIDs);
  Future<GroupModel?> create(GroupCreateRequestModel group);
  Future<void> update(GroupUpdateRequestModel group);
  Future<void> delete(int groupID);
}

class GroupsDataProvider implements IGroupsDataProvider {
  final Client _httpClient;

  GroupsDataProvider({required Client httpClient}) : _httpClient = httpClient;

  @override
  Future<List<GroupModel>> getAll() async {
    final api = _httpClient.get(Uri(path: '/api/groups'));
    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => GroupModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateSortGroups(List<int> sortedGroupIDs) async {
    await _httpClient.post(Uri(path: '/api/groups/update_sort'), body: sortedGroupIDs);
  }

  @override
  Future<void> update(GroupUpdateRequestModel group) async {
    await _httpClient.put(Uri(path: '/api/groups/${group.groupID}'), body: group);
  }

  @override
  Future<GroupModel?> create(GroupCreateRequestModel group) async {
    final api = _httpClient.post(Uri(path: '/api/groups'), body: group);
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      return null;
    }
    return GroupModel.fromJson(json);
  }

  @override
  Future<void> delete(int groupID) async {
    await _httpClient.delete(Uri(path: '/api/groups/$groupID'));
  }
}
