import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/form_service_create_widget.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/service_item_widget.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_cubit.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class ServicesListWidget extends StatelessWidget {
  final CarModel car;
  final GroupModel selectedGroup;
  const ServicesListWidget(this.car, this.selectedGroup, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesCubit(car, selectedGroup)..getByGroupID(),
      child: BlocConsumer<ServicesCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AppStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ServicesState) {
            if (state.services.isEmpty) {
              return FormServiceCreateWidget(car, selectedGroup);
            }

            return ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, i) {
                return ServiceItemWidget(state.services[i]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
