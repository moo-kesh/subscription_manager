import 'package:flutter/material.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 50.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.borderRadius = 12.0,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _triggerAnimation() async {
    if (!mounted || _isAnimating) return;
    _isAnimating = true;
    try {
      await _animationController.forward().orCancel;
      if (mounted) {
        await _animationController.reverse().orCancel;
      }
    } finally {
      if (mounted) {
        _isAnimating = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height,
          child: ElevatedButton(
            onPressed: widget.onPressed != null
                ? () async {
                    await _triggerAnimation();
                    widget.onPressed!(); // Call the user's function immediately
                  }
                : null,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: widget.padding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  elevation: 0, // No elevation, animation provides feedback
                  splashFactory:
                      NoSplash.splashFactory, // Disable ripple effect
                ).copyWith(
                  // Ensure the button does not show a splash effect
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) Icon(widget.icon, size: 20.0),
                if (widget.icon != null && widget.text.isNotEmpty)
                  const SizedBox(width: 8.0),
                if (widget.text.isNotEmpty) Text(widget.text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
