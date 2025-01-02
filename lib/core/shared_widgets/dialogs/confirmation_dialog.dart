import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? btnOkText,
  String? btnNoText,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => SimpleDialog(
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      title: Text(title),
      children: [
        ConfirmationDialog(
          message: message,
          btnOkText: btnOkText,
          btnNoText: btnNoText,
        ),
      ],
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String? btnOkText;
  final String? btnNoText;

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.btnOkText,
    this.btnNoText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Text(message),
        Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(btnNoText ?? 'Нет'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(btnOkText ?? 'Да'),
            ),
          ],
        ),
      ],
    );
  }
}
