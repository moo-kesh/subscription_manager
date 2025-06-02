import 'package:flutter/material.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/core/animations/scale_animation.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = isSelected ? kPrimaryColor : kSurfaceColor;
    final textColor = Colors.white;

    return ScaleAnimationWidget(
      child: GestureDetector(
        onTap: () => onSelected(!isSelected),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
