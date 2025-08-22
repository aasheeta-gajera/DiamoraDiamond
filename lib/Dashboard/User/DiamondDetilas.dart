
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../Models/DiamondModel.dart';

class Diamond3DViewScreen extends StatelessWidget {
  final Diamond diamond;

  const Diamond3DViewScreen({Key? key, required this.diamond}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModelViewer(
      src: 'https://bc6d-157-32-84-33.ngrok-free.app/d2.glb',
      alt: "Diamond 3D model",
      ar: true,
      autoRotate: true, cameraControls: true,
      backgroundColor: Colors.white,
    ),

    );
  }
}