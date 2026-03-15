import 'package:flutter/material.dart';

class AppCardTitle extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Widget? action;
  const AppCardTitle({
    required this.title,
    this.action,
    this.titleColor = Colors.white,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        border: Border.all(color: backgroundColor ?? Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
        child: action != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor)),
                  action!,
                ],
              )
            : Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor)),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final AppCardTitle? title;
  final Widget? child;

  const AppCard({this.title, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) title!,
          if (child != null)
            Padding(
              padding: title != null
                  ? const EdgeInsetsGeometry.fromLTRB(20, 40, 20, 40)
                  : const EdgeInsetsGeometry.all(20),
              child: child,
            ),
        ],
      ),
    );
  }
}
