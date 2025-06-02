import 'package:flutter/material.dart';

class ScaleSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  ScaleSlidePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return ScaleSlideTransition(
             animation: animation,
             secondaryAnimation: secondaryAnimation,
             child: child,
           );
         },
       );
}

class ScaleSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const ScaleSlideTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Animation for the outgoing screen
    final outgoingSlideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.8, 0.0), // Slide to left
        ).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut),
        );

    final outgoingScaleAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.7, // Scale down to 70%
        ).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut),
        );

    final outgoingOpacityAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.5, // Fade out to 50% opacity
        ).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut),
        );

    // Animation for the incoming screen (home screen)
    final incomingSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Start from right
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    final incomingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

    return Stack(
      children: [
        // Outgoing screen - slides left and scales down
        if (secondaryAnimation.value > 0)
          SlideTransition(
            position: outgoingSlideAnimation,
            child: ScaleTransition(
              scale: outgoingScaleAnimation,
              child: FadeTransition(
                opacity: outgoingOpacityAnimation,
                child: Builder(
                  builder: (context) {
                    // This will be handled by the navigation system
                    return Container();
                  },
                ),
              ),
            ),
          ),
        // Incoming screen (home screen) - slides in from right
        SlideTransition(
          position: incomingSlideAnimation,
          child: FadeTransition(
            opacity: incomingOpacityAnimation,
            child: child,
          ),
        ),
      ],
    );
  }
}
