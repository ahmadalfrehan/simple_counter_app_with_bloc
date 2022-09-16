import 'dart:math' as math;

import 'package:flutter/material.dart';

class SecondAnimationMyApp extends StatefulWidget {
  const SecondAnimationMyApp({Key? key}) : super(key: key);

  @override
  State<SecondAnimationMyApp> createState() => _SecondAnimationMyAppState();
}

class _SecondAnimationMyAppState extends State<SecondAnimationMyApp>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    final curved = CurvedAnimation(
      parent: animationController as Animation<double>,
      curve: Curves.bounceInOut,
      reverseCurve: Curves.easeInOut,
    );
    animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(curved)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController!.forward();
        }
      });
    animationController!.forward();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.rotate(
        angle: animation!.value,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/lana.jpg'))),
        ),
      ),
    );
  }
}
