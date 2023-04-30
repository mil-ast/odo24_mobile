import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class GroupsSelectorWidget extends StatelessWidget {
  final List<GroupModel> groups;
  final GroupModel? selected;
  const GroupsSelectorWidget(this.groups, this.selected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: DropdownButton<GroupModel>(
              key: UniqueKey(),
              isExpanded: true,
              value: selected,
              items: groups.map((GroupModel group) {
                return DropdownMenuItem<GroupModel>(
                  key: UniqueKey(),
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
                BlocProvider.of<GroupsCubit>(context).onChangeGroup(group);
              },
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () {
                context.read<GroupsCubit>().onClickOpenGroupsSettingsDialog();
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
    );
  }
}
