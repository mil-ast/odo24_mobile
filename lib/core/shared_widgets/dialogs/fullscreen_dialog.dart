import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';

Future<T?> showFullScreenDialog<T>(BuildContext context, {required String title, required Widget body}) {
  return showDialog<T>(
    context: context,
    builder: (_) => Dialog.fullscreen(
      child: AppScaffold(
        title: title,
        body: SingleChildScrollView(child: body),
      ),
    ),
  );
}
