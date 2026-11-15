import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupModel group;
  final int carOdo;
  const GroupItemWidget({required this.group, required this.carOdo, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupExtraData = group.groupExtraDataModel;
    return ListTile(
      title: Text(group.name, overflow: TextOverflow.fade, maxLines: 1),
      subtitle: groupExtraData != null
          ? Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: nextODOColor(
                    carOdo: carOdo,
                    odo: groupExtraData.odo,
                    leftOdo: groupExtraData.leftOdo,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    '${groupExtraData.leftOdo.format()} км',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.inverseTextColor,
                    ),
                  ),
                ),
              ),
            )
          : null,
      contentPadding: const EdgeInsets.only(
        top: 6,
        right: 4,
        bottom: 6,
        left: 20,
      ),
      onTap: () {
        context.read<GroupsCubit>().onSelectGroup(group);
      },
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  context.read<GroupsCubit>().showUpdateDialog(group);
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 12),
                    Text('Изменить'),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  context.read<GroupsCubit>().showDeleteConfirmDialog(group);
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Удалить', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right_outlined, color: Colors.grey),
        ],
      ),
    );
  }
}
