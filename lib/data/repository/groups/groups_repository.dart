import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/repository/groups/models/group_create_request_model.dart';
import 'package:odo24_mobile/data/repository/groups/models/group_result_dto.dart';
import 'package:odo24_mobile/data/repository/groups/models/group_update_request_model.dart';

class GroupsRepository {
  final _api = HttpAPI.newDio();

  Future<List<GroupDTO>> getAll() async {
    final api = _api.get('/api/groups');

    final json = await ResponseHandler.parseListJSON(api);
    if (json == null) {
      return [];
    }
    return json.map((e) => GroupDTO.fromJson(e)).toList();
  }

  Future<void> updateSortGroups(List<int> sortedGroupIDs) async {
    await _api.post('/api/groups/update_sort', data: sortedGroupIDs);
  }

  Future<void> update(GroupUpdateRequestModel group) async {
    await _api.put('/api/groups/${group.groupID}', data: group);
  }

  Future<GroupDTO> create(GroupCreateRequestModel group) async {
    final api = _api.post('/api/groups', data: group);
    final json = await ResponseHandler.parseJSON(api);
    return GroupDTO.fromJson(json);
  }

  Future<void> delete(int groupID) async {
    await _api.delete('/api/groups/$groupID');
  }
}
