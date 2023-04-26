import 'package:odo24_mobile/repository/cars/car_update_dto.dart';
import 'package:odo24_mobile/repository/groups/group_create_request_model.dart';
import 'package:odo24_mobile/repository/groups/group_result_dto.dart';
import 'package:odo24_mobile/repository/groups/group_update_request_model.dart';
import 'package:odo24_mobile/repository/groups/groups_repository.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class GroupsService {
  static final _instance = GroupsService._internal();

  factory GroupsService() {
    return _instance;
  }

  GroupsService._internal();

  final _repository = GroupsRepository();

  Future<List<GroupModel>> getAll() async {
    final result = await _repository.getAll();

    return result.map((dto) => GroupModel.fromDTO(dto)).toList();
  }

  Future<void> updateSortGroups(List<int> sortedGroupIDs) {
    return _repository.updateSortGroups(sortedGroupIDs);
  }

  Future<void> update(GroupUpdateRequestModel group) {
    return _repository.update(group);
  }

  Future<GroupModel> create(GroupCreateRequestModel group) async {
    final dto = await _repository.create(group);
    return GroupModel.fromDTO(dto);
  }

  Future<void> delete(int groupID) {
    return _repository.delete(groupID);
  }

  /* Future<CarModel> create(CarCreateDTO car) async {
    final result = await _repository.create(car);
    return CarModel.fromDTO(result);
  }


  Future<void> delete(CarModel car) {
    return _repository.delete(car.carID);
  } */
}
