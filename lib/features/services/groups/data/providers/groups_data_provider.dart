import 'package:dio/dio.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_create_request_model.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_update_request_model.dart';

abstract interface class IGroupsDataProvider {
  Future<Response<Object>> getAll();
  Future<Response<void>> updateSortGroups(List<int> sortedGroupIDs);
  Future<Response<Object>> create(GroupCreateRequestModel group);
  Future<Response<void>> update(GroupUpdateRequestModel group);
  Future<Response<void>> delete(int groupID);
}

class GroupsDataProvider implements IGroupsDataProvider {
  final Dio _httpClient;

  GroupsDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<Response<Object>> getAll() {
    return _httpClient.get('/api/groups');
  }

  @override
  Future<Response<void>> updateSortGroups(List<int> sortedGroupIDs) {
    return _httpClient.post('/api/groups/update_sort', data: sortedGroupIDs);
  }

  @override
  Future<Response<void>> update(GroupUpdateRequestModel group) {
    return _httpClient.put('/api/groups/${group.groupID}', data: group);
  }

  @override
  Future<Response<Object>> create(GroupCreateRequestModel group) {
    return _httpClient.post('/api/groups', data: group);
  }

  @override
  Future<Response<void>> delete(int groupID) {
    return _httpClient.delete('/api/groups/$groupID');
  }
}
