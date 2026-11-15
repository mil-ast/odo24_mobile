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
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ConfirmationDialog(
          title: title,
          message: message,
          btnOkText: btnOkText,
          btnNoText: btnNoText,
        ),
      ),
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? btnOkText;
  final String? btnNoText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.btnOkText,
    this.btnNoText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 24,
                  color: accent,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 12,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(btnNoText ?? 'Нет'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(btnOkText ?? 'Да'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
