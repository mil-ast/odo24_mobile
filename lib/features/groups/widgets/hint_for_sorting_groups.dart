import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';

class HintForSortingGroups extends StatefulWidget {
  static const _hintForSortingVisibleSPKey = 'hintForSortingVisibleSPKey';

  const HintForSortingGroups({super.key});

  @override
  State<HintForSortingGroups> createState() => _HintForSortingGroupsState();
}

class _HintForSortingGroupsState extends State<HintForSortingGroups> {
  bool hidden = false;

  @override
  void initState() {
    super.initState();

    final sp = DependenciesScope.of(context).sharedPreferences;
    final value = sp.getBool(HintForSortingGroups._hintForSortingVisibleSPKey);
    if (value != null && value != hidden) {
      setState(() {
        hidden = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hidden) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(
        color: ODO24Colors.actions,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        spacing: 10,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: ODO24Colors.inverseTextColor,
            size: 22,
          ),
          const Expanded(
            child: Text(
              'Перетащите группу за ручку справа, чтобы изменить порядок',
              style: TextStyle(
                color: ODO24Colors.inverseTextColor,
                height: 1.3,
              ),
            ),
          ),
          IconButton(
            onPressed: _hide,
            tooltip: 'Скрыть подсказку',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close_rounded,
              color: ODO24Colors.inverseTextColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _hide() async {
    final sp = DependenciesScope.of(context).sharedPreferences;
    await sp.setBool(HintForSortingGroups._hintForSortingVisibleSPKey, true);

    setState(() {
      hidden = true;
    });
  }
}
