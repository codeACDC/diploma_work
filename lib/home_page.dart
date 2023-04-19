import 'dart:io';

import 'package:camera/camera.dart';
import 'package:diploma_work/bounding_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MyHomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDetecting = false;
  late CameraController _cameraController;
  List? recognition = [];

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: 'assets/detect1.tflite', labels: 'assets/labels.txt');
  }

  void cameraInitialization() async {
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _cameraController.startImageStream((CameraImage image) {
        if (!isDetecting) {
          isDetecting = true;
          Tflite.detectObjectOnFrame(
            model: 'YOLO',
            bytesList: image.planes.map((e) => e.bytes).toList(),
            imageWidth: image.width,
            imageHeight: image.height,
            imageMean: 0,
            imageStd: 255,
            numResultsPerClass: 1,
            threshold: 0.2,
          ).then((value) {
            if (value != null) {
              setState(() {
                recognition = value;
              });
            }
            isDetecting = false;
          }).catchError((Object e) {
            debugPrint(e.toString());
          });
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('Camera access denied!');
            exit(0);
            break;

          default:
            debugPrint('Try again!');
            break;
        }
      }
    });
  }

  @override
  void initState() {
    loadModel();
    cameraInitialization();
    super.initState();
  }

  @override
  void dispose() async {
    await Tflite.close();
    _cameraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Объектилерди аныктоо',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _cameraController.value.isInitialized
          ? LayoutBuilder(builder: (context, constraint) {
              return Stack(
                children: [
                  SizedBox(
                      width: constraint.maxWidth,
                      height: constraint.maxHeight,
                      child: CameraPreview(_cameraController)),
                  BoundingBoxWidget(prediction: recognition),
                ],
              );
            })
          : Container(),
    );
  }
}
