import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';

class TitleToolBarWidget extends StatelessWidget {
  final String title;
  final IconButton? actionButton;
  const TitleToolBarWidget({
    required this.title,
    this.actionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: ODO24Colors.primary,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 0, bottom: 10, left: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            if (actionButton != null) actionButton!,
          ],
        ),
      ),
    );
  }
}
