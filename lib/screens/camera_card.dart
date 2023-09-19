import 'dart:io';

import 'package:camera/camera.dart';
import 'package:captured_card/cam_overlay/cam_overlay_model.dart';
import 'package:captured_card/screens/second_screen.dart';
import 'package:flutter/material.dart';

import '../cam_overlay/cam_overlay.dart';

class CardCameraScreen extends StatefulWidget {
  const CardCameraScreen({super.key});

  @override
  State<CardCameraScreen> createState() => _CardCameraScreenState();
}

class _CardCameraScreenState extends State<CardCameraScreen> {
  OverlayFormat format = OverlayFormat.cardID3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                alignment: Alignment.center,
                child: Text(
                  'No camera found',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
            return CustomCameraOverlay(
              snapshot.data!.first,
              CardOverlay.byFormat(format),
              info:
                  'Position your ID card within the rectangle and ensure the image is perfectly readable.',
              label: 'Scanning ID Card',
              (XFile file) => showDialog(
                context: context,
                barrierColor: Colors.black,
                builder: (context) {
                  CardOverlay overlay = CardOverlay.byFormat(format);
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    backgroundColor: Colors.black,
                    title: const Text(
                      'Capture',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image Saved Success'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          ///
                          // save image and view it in second screen

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SecondScreen(
                                    file: file, overlay: overlay);
                              },
                            ),
                          );
                        },
                        child: const Icon(Icons.check),
                      ),
                    ],
                    content: SizedBox(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: overlay.ratio!,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: FileImage(
                                File(file.path),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Align(
              alignment: Alignment.center,
              child: Text(
                'Fetching cameras',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
    );
  }
}
