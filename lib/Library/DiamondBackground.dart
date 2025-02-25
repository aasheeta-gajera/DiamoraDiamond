
import 'package:flutter/material.dart';

class DiamondBackground extends StatelessWidget {
  const DiamondBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -100,
          top: -30,
          child: Transform.rotate(
            angle: 0.6,
            child: _backgroundShape(Colors.blue[50]!, Colors.blue[50]!, 180, 180, 18),
          ),
        ),
        Positioned(
          left: 75,
          bottom: 70,
          child: Transform.rotate(
            angle: 0.7,
            child: _backgroundShape(Colors.blue[50]!, Colors.blue[50]!, 50, 50, 18),
          ),
        ),
        Positioned(
          left: -110,
          bottom: 250,
          child: Transform.rotate(
            angle: 0.7,
            child: _backgroundShape(Colors.blue[100]!, Colors.blue[100]!, 180, 180, 18),
          ),
        ),
        Positioned(
          right: -130,
          bottom: -20,
          child: Transform.rotate(
            angle: 0.6,
            child: _backgroundShape(Colors.blue[100]!, Colors.blue[100]!, 450, 250, 18),
          ),
        ),
        Positioned(
          left: -60,
          bottom: 40,
          child: Transform.rotate(
            angle: 0.7,
            child: _backgroundShape(Colors.blue[100]!, Colors.blue[100]!, 100, 100, 18),
          ),
        ),
      ],
    );
  }

  Widget _backgroundShape(Color startColor, Color endColor, double height, double width, double borderRadius) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
