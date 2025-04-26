import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../Models/DiamondModel.dart'; // Assuming this is your model file for Diamond

class Diamond3DViewScreen extends StatelessWidget {
  final Diamond diamond;

  const Diamond3DViewScreen({Key? key, required this.diamond}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Diamond 3D View'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // 3D Model viewer
          Expanded(
            child: ModelViewer(
              src: 'assets/models/scene.gltf', // Path to the .glb or .gltf file
              alt: "A 3D diamond model",
              autoRotate: true,  // Enable auto-rotation
              cameraControls: true, // Enable zoom and rotation controls
              backgroundColor: Colors.transparent, // Transparent background
            ),
          ),
          // Information about the diamond
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${diamond.supplier}", style: TextStyle(color: Colors.white)),
                Text("Carat: ${diamond.certification}", style: TextStyle(color: Colors.white70)),
                Text("Clarity: ${diamond.clarity}", style: TextStyle(color: Colors.white70)),
                Text("Cut: ${diamond.cut}", style: TextStyle(color: Colors.white70)),
                Text("Price: ${diamond.totalDiamonds}", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
