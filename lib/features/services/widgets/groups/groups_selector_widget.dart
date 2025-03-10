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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<GroupModel>(
              focusColor: theme.dropdownMenuTheme.inputDecorationTheme?.fillColor,
              dropdownColor: theme.dropdownMenuTheme.inputDecorationTheme?.fillColor,
              iconEnabledColor: theme.colorScheme.primary,
              style: theme.dropdownMenuTheme.textStyle,
              decoration: InputDecoration(
                fillColor: theme.dropdownMenuTheme.inputDecorationTheme?.fillColor,
                enabledBorder: theme.dropdownMenuTheme.inputDecorationTheme?.border,
                focusedBorder: theme.dropdownMenuTheme.inputDecorationTheme?.border,
              ),
              value: selected,
              isExpanded: true,
              items: groups.map((GroupModel group) {
                return DropdownMenuItem<GroupModel>(
                  key: ValueKey(group.groupID),
                  value: group,
                  child: Text(
                    group.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: BlocProvider.of<GroupsCubit>(context).onChangeGroup,
              icon: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 24,
                  color: theme.dropdownMenuTheme.textStyle?.color,
                ),
              ),
              //iconEnabledColor: theme.colorScheme.inversePrimary,
              //underline: const SizedBox.shrink(), //remove underline
            ),
            /* child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButton<GroupModel>(
                  value: selected,
                  isExpanded: true,
                  items: groups.map((GroupModel group) {
                    return DropdownMenuItem<GroupModel>(
                      key: ValueKey(group.groupID),
                      value: group,
                      child: Text(
                        group.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: BlocProvider.of<GroupsCubit>(context).onChangeGroup,
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: theme.colorScheme.inversePrimary,
                    ),
                  ),
                  iconEnabledColor: theme.colorScheme.inversePrimary,
                  underline: const SizedBox.shrink(), //remove underline
                ),
              ),
            ), */
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: IconButton(
                onPressed: context.read<GroupsCubit>().onClickOpenGroupsSettingsScreen,
                icon: const Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
