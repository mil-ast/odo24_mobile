import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/car_screen_cubit.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/groups_settings/groups_settings_dialog.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

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
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CarScreenCubit>(
              create: (context) => CarScreenCubit()..getAllGroups(),
            ),
          ],
          child: BlocConsumer<CarScreenCubit, AppState>(
            listenWhen: (previous, current) => current is AppStateError || current is ListenGroupsState,
            listener: (context, state) {
              if (state is OpenGroupsSettingDialogState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupsSettingsDialog(context.read<CarScreenCubit>(), state.groups),
                    fullscreenDialog: false,
                  ),
                ).then((value) {
                  context.read<CarScreenCubit>().refresh();
                });
                /* showDialog(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                    title: const Text('Добавление авто'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      GroupsSettingsDialog(state.groups),
                    ],
                  ),
                ); */
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
                  children: [
                    Container(
                      color: Colors.white,
                      height: 80,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton<GroupModel>(
                              isExpanded: true,
                              value: state.selected,
                              items: state.groups.map((GroupModel group) {
                                return DropdownMenuItem<GroupModel>(
                                  value: group,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(group.name),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (group) {
                                context.read<CarScreenCubit>().onChangeGroup(group);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () {
                                context.read<CarScreenCubit>().onClickOpenGroupsSettingsDialog();
                              },
                              icon: const Icon(Icons.settings),
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Color(0xFF5abd70)),
                                iconColor: MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
