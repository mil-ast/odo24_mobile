import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';

/// Компактный чип с иконкой и значением для метаданных карточки.
class MetaChip extends StatelessWidget {
  static const _neutralBackground = Color(0xFFF2F3F5);

  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final String? tooltip;

  const MetaChip({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isAction = onTap != null;
    final tinted = isAction || color != null;
    final foreground =
        color ?? (isAction ? ODO24LightThemeColors.active : Colors.black87);

    final chip = Material(
      color: tinted ? foreground.withValues(alpha: 0.07) : _neutralBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: tinted
            ? BorderSide(color: foreground.withValues(alpha: 0.25))
            : BorderSide.none,
      ),
      child: isAction
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(100),
              overlayColor: WidgetStatePropertyAll(
                foreground.withValues(alpha: 0.12),
              ),
              child: _buildContent(context, foreground, tinted),
            )
          : _buildContent(context, foreground, tinted),
    );

    if (!isAction || tooltip == null) {
      return chip;
    }
    return Tooltip(message: tooltip!, child: chip);
  }

  Widget _buildContent(BuildContext context, Color foreground, bool tinted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 15, color: tinted ? foreground : Colors.black45),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: tinted ? foreground : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
