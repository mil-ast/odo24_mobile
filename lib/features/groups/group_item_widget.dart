import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/core/shared_widgets/meta_chip.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupModel group;
  final int carOdo;
  final int index;

  const GroupItemWidget({required this.group, required this.carOdo, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupExtraData = group.groupExtraDataModel;
    final statusColor = groupExtraData == null
        ? null
        : nextODOColor(carOdo: carOdo, odo: groupExtraData.odo, leftOdo: groupExtraData.leftOdo);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.read<GroupsCubit>().onSelectGroup(group),
          overlayColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.03)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
            child: Row(
              children: [
                _GroupAvatar(name: group.name, statusColor: statusColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (groupExtraData != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            MetaChip(
                              icon: Icons.speed_rounded,
                              label: '${groupExtraData.leftOdo.format()} км',
                              color: statusColor,
                            ),
                            Text('до обслуживания', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
                          ],
                        )
                      else
                        Text('Нет данных о пробеге', style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45)),
                    ],
                  ),
                ),
                _GroupActionsMenu(group: group),
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.drag_indicator_rounded, size: 20, color: Colors.black26),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupAvatar extends StatelessWidget {
  final String name;
  final Color? statusColor;

  const _GroupAvatar({required this.name, this.statusColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedName = name.trim();

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              trimmedName.isEmpty ? '?' : trimmedName.substring(0, 1).toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.black45, fontWeight: FontWeight.w600),
            ),
          ),
          if (statusColor != null)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _GroupAction { edit, delete }

class _GroupActionsMenu extends StatelessWidget {
  final GroupModel group;

  const _GroupActionsMenu({required this.group});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_GroupAction>(
      tooltip: 'Действия',
      icon: const Icon(Icons.more_vert_rounded, color: Colors.black45),
      onSelected: (action) {
        final cubit = context.read<GroupsCubit>();
        switch (action) {
          case _GroupAction.edit:
            cubit.showUpdateDialog(group);
          case _GroupAction.delete:
            cubit.showDeleteConfirmDialog(group);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _GroupAction.edit,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(spacing: 12, children: [Icon(Icons.edit_outlined), Text('Изменить')]),
        ),
        PopupMenuItem(
          value: _GroupAction.delete,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(
            spacing: 12,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.red),
              Text('Удалить', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
