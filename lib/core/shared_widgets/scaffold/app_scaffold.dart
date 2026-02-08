import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/shared_widgets/app_bar/app_bar.dart';

class AppScaffold extends StatelessWidget {
  final bool automaticallyImplyLeading;
  final String? title;
  final String? subTitle;
  final Widget body;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final List<Widget>? persistentFooterButtons;
  final EdgeInsetsGeometry padding;

  const AppScaffold({
    super.key,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subTitle,
    required this.body,
    this.appBarActions,
    this.floatingActionButton,
    this.persistentFooterButtons,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? CustomAppBar(
              automaticallyImplyLeading: automaticallyImplyLeading,
              title: title!,
              subTitle: subTitle,
              actions: appBarActions,
            )
          : null,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: AlignmentDirectional.center,
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding: padding,
        child: body,
        /* child: ClipRRect(
          borderRadius: title != null
              ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              : BorderRadius.zero,
          child: body,
        ), */
      ),
    );
  }
}
