import 'package:flutter/cupertino.dart';

class SlideFadeAnimationWidget extends StatefulWidget {
  const SlideFadeAnimationWidget({super.key, this.child, this.duration});

  final Widget? child;
  final Duration? duration;

  @override
  State<SlideFadeAnimationWidget> createState() =>
      _SlideFadeAnimationWidgetState();
}

class _SlideFadeAnimationWidgetState extends State<SlideFadeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.2), // Start slightly below
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}
