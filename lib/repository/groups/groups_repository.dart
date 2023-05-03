import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/groups/models/group_create_request_model.dart';
import 'package:odo24_mobile/repository/groups/models/group_result_dto.dart';
import 'package:odo24_mobile/repository/groups/models/group_update_request_model.dart';

class GroupsRepository {
  final _api = HttpAPI.newDio();

  Future<List<GroupDTO>> getAll() async {
    final result = await _api.get('/api/groups');

    final List<dynamic>? json = ResponseHandler.parse(result);
    if (json == null) {
      return [];
    }
    return json.map((e) => GroupDTO.fromJson(e)).toList();
  }

  Future<void> updateSortGroups(List<int> sortedGroupIDs) {
    return _api.post('/api/groups/update_sort', data: sortedGroupIDs).then((value) => null);
  }

  Future<void> update(GroupUpdateRequestModel group) {
    return _api.put('/api/groups/${group.groupID}', data: group);
  }

  Future<GroupDTO> create(GroupCreateRequestModel group) async {
    final result = await _api.post('/api/groups', data: group);
    final Map<String, dynamic> json = ResponseHandler.parse(result);
    return GroupDTO.fromJson(json);
  }

  Future<void> delete(int groupID) {
    return _api.delete('/api/groups/$groupID');
  }
}
