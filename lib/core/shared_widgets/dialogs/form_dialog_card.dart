import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';

/// Белая карточка с шапкой и формой — общий вид для диалогов и встроенных форм.
class FormDialogCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final IconData icon;
  final String title;
  final String? description;
  final Color accentColor;
  final List<Widget> children;

  const FormDialogCard({
    required this.formKey,
    required this.icon,
    required this.title,
    required this.children,
    this.description,
    this.accentColor = ODO24LightThemeColors.active,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 26, color: accentColor),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (description != null)
                            Text(
                              description!,
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
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Разделитель и кнопки действий в нижней части формы.
class FormDialogActions extends StatelessWidget {
  final String cancelLabel;
  final String submitLabel;
  final IconData? submitIcon;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const FormDialogActions({
    required this.submitLabel,
    required this.onCancel,
    required this.onSubmit,
    this.cancelLabel = 'Отмена',
    this.submitIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1, color: Color(0xFFEDEFF2)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 12,
          children: [
            TextButton(onPressed: onCancel, child: Text(cancelLabel)),
            if (submitIcon != null)
              FilledButton.icon(
                onPressed: onSubmit,
                icon: Icon(submitIcon),
                label: Text(submitLabel),
              )
            else
              FilledButton(onPressed: onSubmit, child: Text(submitLabel)),
          ],
        ),
      ],
    );
  }
}
