import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';

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
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xfff9f9f9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton<GroupModel>(
                  value: selected,
                  isExpanded: true,
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
                  onChanged: BlocProvider.of<GroupsCubit>(context).onChangeGroup,
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_drop_down_outlined, color: Colors.black87),
                  ),
                  iconEnabledColor: Colors.black87,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  underline: const SizedBox.shrink(), //remove underline
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: context.read<GroupsCubit>().onClickOpenGroupsSettingsScreen,
              icon: const Icon(Icons.settings),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
