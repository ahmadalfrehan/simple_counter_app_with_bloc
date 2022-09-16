import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:such/Camera/CameraScreen.dart';
import 'package:such/animation/ExampleAnimation.dart';
import 'package:such/animation/secondAnimationMyApp.dart';


import '../main.dart';

class AnimationMyApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AnimationMyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  State<AnimationMyApp> createState() => AnimationMyAppState();
}

class AnimationMyAppState extends State<AnimationMyApp>
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
        child: Column(
          children: const [
            Center(
              child: CircleAvatar(
                maxRadius: 180,
                backgroundImage: AssetImage('assets/lana.jpg'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const SecondAnimationMyApp();
              }));
            },
            child: const Icon(Icons.forward),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CameraScreen(cameras: widget.cameras);
              }));
            },
            child: const Icon(Icons.forward),
          ),
          /*FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MyHomePage();
              }));
            },
            child: const Icon(Icons.forward),
          ),*/
          /*FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ExampleAnimation();
              }));
            },
            child: const Icon(Icons.forward),
          ),*/
        ],
      ),
    );
  }
}
