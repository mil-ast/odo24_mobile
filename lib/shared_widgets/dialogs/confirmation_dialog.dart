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
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
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

  ConfirmationDialog({
    required this.message,
    this.btnOkText,
    this.btnNoText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(btnNoText ?? 'Нет'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
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
