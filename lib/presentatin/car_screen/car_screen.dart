import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/groups_settings/groups_settings_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/groups_selector_widget.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_list_widget.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class CarScreen extends StatelessWidget {
  final CarModel car;
  const CarScreen(this.car, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 80,
        leadingWidth: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              car.name,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text('${car.odo} км', style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GroupsCubit>(
              create: (context) => GroupsCubit()..getAllGroups(),
            ),
          ],
          child: BlocConsumer<GroupsCubit, AppState>(
            listenWhen: (previous, current) => current is AppStateError || current is ListenGroupsState,
            listener: (context, state) {
              if (state is OpenGroupsSettingDialogState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupsSettingsDialog(
                      context.read<GroupsCubit>(),
                      state.groups,
                    ),
                    fullscreenDialog: false,
                  ),
                ).then((value) {
                  context.read<GroupsCubit>().refresh();
                });
              }
            },
            buildWhen: (previous, current) => current is BuildGroupsState || current is AppStateLoading,
            builder: (context, state) {
              if (state is AppStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is GroupsState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GroupsSelectorWidget(state.groups, state.selected),
                    if (state.selected != null)
                      Expanded(
                        child: ServicesListWidget(car, state.selected!, key: UniqueKey()),
                      ),
                  ],
                );
              }

              /* if (state is GroupsState) {
                if (state.groups.isEmpty) {
                  return FormGroupCreateWidget();
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GroupsSelectorWidget(state.groups, state.selected),
                      if (state.selected != null)
                        Expanded(
                          child: SingleChildScrollView(child: ServicesListWidget(car, state.selected!)),
                        ),
                    ],
                  ),
                );
              } */

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
