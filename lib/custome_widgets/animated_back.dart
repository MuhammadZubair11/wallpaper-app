import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

class StarBackground extends StatefulWidget {
  final Widget child;
  const StarBackground({required this.child, Key? key}) : super(key: key);

  @override
  _StarBackgroundState createState() => _StarBackgroundState();
}

class _StarBackgroundState extends State<StarBackground>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: ParticleOptions(
          baseColor: Colors.teal,
          spawnOpacity: 0.0,
          opacityChangeRate: 0.25,
          minOpacity: 0.1,
          maxOpacity: 0.4,
          particleCount: 50,
          spawnMaxRadius: 6.0,
          spawnMaxSpeed: 30.0,
          spawnMinSpeed: 30,
          spawnMinRadius: 3.0,
        ),
      ),
      vsync: this,
      child: widget.child,
    );
  }
}
