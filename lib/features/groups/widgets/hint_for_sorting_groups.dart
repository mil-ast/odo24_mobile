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
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.only(bottom: 20),
      color: ODO24Colors.actions,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: Row(
          spacing: 10,
          children: [
            const Expanded(
              child: Text(
                'Удерживайте группу полсекунды и далее переместите ее в нужную позицию',
                style: TextStyle(color: ODO24Colors.inverseTextColor),
              ),
            ),
            IconButton(onPressed: _hide, icon: const Icon(Icons.close)),
          ],
        ),
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
