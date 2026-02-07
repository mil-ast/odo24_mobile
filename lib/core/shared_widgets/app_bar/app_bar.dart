import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.automaticallyImplyLeading, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
