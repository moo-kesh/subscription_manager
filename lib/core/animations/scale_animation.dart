import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScaleAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ScaleAnimationWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOut,
  });

  @override
  State<ScaleAnimationWidget> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    SchedulerBinding.instance.addPostFrameCallback((_) {
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
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
