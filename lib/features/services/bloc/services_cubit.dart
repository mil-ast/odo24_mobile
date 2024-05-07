import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_states.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final IServicesRepository _servicesRepository;
  final CarModel selectedCar;

  GroupModel? selectedGroup;

  ServicesCubit({
    required this.selectedCar,
    required IServicesRepository servicesRepository,
  })  : _servicesRepository = servicesRepository,
        super(ServicesState.ready());

  Future<void> onChangeSelectedGroup(GroupModel selectedGroup) async {
    emit(ServicesState.idle());

    final services = await _servicesRepository.getByCarAndGroup(selectedCar.carID, selectedGroup.groupID);
    services.sort(
      (a, b) {
        if (a.odo != null && b.odo != null) {
          return b.odo! - a.odo!;
        }
        return 0;
      },
    );

    for (int i = 0; i < services.length; i++) {
      if (i != services.length - 1) {
        final currModel = services.elementAt(i);
        final prevModel = services.elementAt(i + 1);
        if (prevModel.odo != null && currModel.odo != null) {
          final distance = currModel.odo! - prevModel.odo!;
          if (distance > 0) {
            currModel.leftDistance = distance;
          }
        }
      }
    }

    emit(ServicesState.showList(services));
  }
}
