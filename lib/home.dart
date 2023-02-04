import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  int count = 0;
  double? noseX;
  bool isMovingUp = false;

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String? res;
    switch (_model) {
      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  incrementCount() {
    setState(() {
      count++;
    });
  }

  detectMovement(){
    if(_recognitions != null && _recognitions!.length > 0) {
      _recognitions![0]["keypoints"].values.forEach((k) {
        if (k['part'] == 'nose' && k['score'] > 0.6) {
          double x = k["x"];
          print("X: $x ");
          if (noseX == null) {
            noseX = x;
            print("noseX: $noseX ");
          } else {
            double diff = x - noseX!;
            print("diff: $diff ");
            if (diff < -0.01) {
              if (!isMovingUp) {
                isMovingUp = true;
              }
            } else if (diff > 0.01 ) {
              if (isMovingUp) {
                isMovingUp = false;
                incrementCount();
                print("Increment count");
              }
            }
            noseX = x;
          }
        }
      });
    }
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });

    detectMovement();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text(posenet),
              onPressed: () => onSelect(posenet),
            ),
          ],
        ),
      )
          : Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          Container(
            padding: EdgeInsets.only(right: 50, top: 50),
            alignment: Alignment.topRight,
            child: Text('Count = $count', style: TextStyle(
              color: Colors.red,
              fontSize: 30
            ),),
          ),
          BndBox(
              _recognitions == null ? [] : _recognitions!,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model,
              incrementCount
          ),
          Container(
            alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      count = 0;
                    });
                  },
                  child: Text('Reset count')
          ))
        ],
      ),
    );
  }
}