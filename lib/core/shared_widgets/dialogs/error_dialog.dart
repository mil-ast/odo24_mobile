import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => SimpleDialog(
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      title: Text(title),
      children: [
        ErrorDialog(
          message: message,
        ),
      ],
    ),
  );
}

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('OK'),
          ),
        )
      ],
    );
  }
}
