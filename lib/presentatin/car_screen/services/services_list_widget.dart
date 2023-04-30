import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_list_cubit.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class ServicesListWidget extends StatelessWidget {
  final CarModel car;
  final GroupModel selectedGroup;
  const ServicesListWidget(this.car, this.selectedGroup, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesListCubit(car, selectedGroup)..getByGroupID(),
      child: BlocConsumer<ServicesListCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Text('foo');
        },
      ),
    );
  }
}
