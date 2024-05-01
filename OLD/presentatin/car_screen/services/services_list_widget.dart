import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/dialogs/service_create_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/dialogs/service_update_dialog.dart';
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
    return BlocConsumer<ServicesCubit, AppState>(
      listenWhen: (previous, current) => current is! BuildServiceState,
      listener: (context, state) {
        if (state is ClickOpenDialogCreateServiceRec) {
          showDialog<void>(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<ServicesCubit>(),
              child: Dialog.fullscreen(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ServiceRecCreateWidget(
                        car: car,
                        selectedGroup: selectedGroup,
                      ),
                    ),
                  ),
                ),
              ),
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
            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Записей ещё нет')),
                //child: FormServiceCreateWidget(car, selectedGroup),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.services.length,
                  itemBuilder: (context, i) => ServiceItemWidget(state.services[i]),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
