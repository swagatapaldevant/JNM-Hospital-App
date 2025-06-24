import 'package:flutter/material.dart';

class StaggeredAnimatedWidget extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const StaggeredAnimatedWidget({
    super.key,
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(0.2 + index * 0.1, 1.0, curve: Curves.easeIn),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2 + index * 0.1, 1.0, curve: Curves.easeOut),
    ));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
