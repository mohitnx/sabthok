import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const DelayedAnimation({required this.child, required this.delay});

  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
//with TickerProicderStateMixin becaus we need to use AnimationController and TickerProivider in vsync
    with
        TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
//going to controll the duration of animation
    _controller = AnimationController(
        //controls duration of animation
        vsync: this,
        duration: const Duration(milliseconds: 300));

    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffset =
        //offset(x,y), x contorls where the animation start, eg:0.8 will make it start from right and come to center
        //y controls the travel,,,higher means, objets travel longer
        Tween<Offset>(begin: const Offset(0.0, 0.17), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //see  flutter:package/src/widgets/transitions.dart for other aniamtion classes, or ctrl+clk
    return FadeTransition(
      opacity: _controller,
      //we want the objects to come from bottom to top, so slideTransition is good for that
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
