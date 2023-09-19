import 'dart:io';

import 'package:camera/camera.dart';
import 'package:captured_card/cam_overlay/cam_overlay_model.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final XFile file;
  final CardOverlay overlay;

  const SecondScreen({super.key, required this.file, required this.overlay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Card'),
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          height: 150,
          child: AspectRatio(
            aspectRatio: overlay.ratio!,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  image: FileImage(
                    File(file.path),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
