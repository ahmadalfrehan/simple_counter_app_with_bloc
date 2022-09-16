import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'GalleryScreen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  Future<void>? initializeControllerFuture;
  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    cameraController = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.medium,
    );
    initializeControllerFuture = cameraController?.initialize();
  }

  @override
  void initState() {
    initializeCamera(selectedCamera);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder<void>(
                  future: initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(cameraController!,
                      );
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  if (widget.cameras.length > 1) {
                    setState(() {
                      selectedCamera =
                          selectedCamera == 0 ? 1 : 0; //Switch camera
                      initializeCamera(selectedCamera);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('No secondary camera found'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                icon: const Icon(Icons.switch_camera_rounded,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: () async {
                  await initializeControllerFuture; //To make sure camera is initialized
                  var xFile = await cameraController?.takePicture();
                  setState(() {
                    capturedImages.add(File(xFile!.path));
                  });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (capturedImages.isEmpty) return; //Return if no image
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryScreen(
                              images: capturedImages.reversed.toList())));
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    image: capturedImages.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(capturedImages.last),
                            fit: BoxFit.cover)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
