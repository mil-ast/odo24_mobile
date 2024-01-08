import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/dialogs/service_create_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/dialogs/service_update_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/form_service_create_widget.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/service_item_widget.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_cubit.dart';
import 'package:odo24_mobile/domain/services/cars/models/car.model.dart';
import 'package:odo24_mobile/domain/services/groups/models/group.model.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';

class ServicesListWidget extends StatelessWidget {
  final CarModel car;
  final GroupModel selectedGroup;
  const ServicesListWidget(this.car, this.selectedGroup, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesCubit(car, selectedGroup)..getByGroupID(),
      child: BlocConsumer<ServicesCubit, AppState>(
        listenWhen: (previous, current) => current is! BuildServiceState,
        listener: (context, state) {
          if (state is ClickOpenDialogCreateServiceRec) {
            showDialog<void>(
              context: context,
              builder: (BuildContext ctx) => SimpleDialog(
                title: const Text('Добавление новой записи'),
                contentPadding: const EdgeInsets.all(20),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ServiceRecCreateWidget(
                      context.read<ServicesCubit>(),
                      car: car,
                      selectedGroup: selectedGroup,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ServiceCreateSuccessful) {
            const SnackBar(
              content: Text('Запись успешно добавлена'),
            );
          } else if (state is ClickUpdateServiceRec) {
            showDialog<void>(
              context: context,
              builder: (BuildContext ctx) => SimpleDialog(
                title: const Text('Изменить запись'),
                contentPadding: const EdgeInsets.all(20),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ServiceRecUpdateWidget(
                      context.read<ServicesCubit>(),
                      service: state.service,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ClickConfirmationDeleteServiceRec) {
            showConfirmationDialog(
              context,
              title: 'Удаление записи',
              message: 'Вы действительно хотите удалить запись от "${state.service.dt}"?',
            ).then((isOk) {
              if (isOk == true) {
                context.read<ServicesCubit>().delete(car, state.service);
              }
            });
          }
        },
        buildWhen: (previous, current) => current is BuildServiceState,
        builder: (context, state) {
          if (state is AppStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ServicesState) {
            if (state.services.isEmpty) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FormServiceCreateWidget(car, selectedGroup),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: context.read<ServicesCubit>().onClickCreateServiceRec,
                      child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Icon(Icons.add),
                          Text('Добавить запись'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.services.length,
                    itemBuilder: (context, i) {
                      return ServiceItemWidget(state.services[i]);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
