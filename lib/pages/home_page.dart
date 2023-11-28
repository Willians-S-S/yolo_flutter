import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:yolo_flutter/pages/bbox.dart';
import 'package:yolo_flutter/models/labels.dart';
import 'package:yolo_flutter/models/yolo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const inModelWidth = 640;
  static const inModelHeight = 640;
  static const numClasses = 80;

  static const double maxImageWidgetHeight = 400;

  final ImagePicker picker = ImagePicker();

  final YoloModel model = YoloModel(
    'assets/models/yolov8s.tflite',
    inModelWidth,
    inModelHeight,
    numClasses,
  );
  File? imageFile;

  double confidenceThreshold = 0.6;
  double iouThreshold = 0.1;

  (List<List<double>>, double, double)? inferenceOutput;
  List<int> classes = [];
  List<List<double>> bboxes = [];
  List<double> scores = [];

  int? imageWidth;
  int? imageHeight;

  @override
  void initState() {
    super.initState();
    model.init();
  }

  void updatePostprocess() {
    print("Segundo");
    if (inferenceOutput == null) {
      return;
    }

    List<int> newClasses = [];
    List<List<double>> newBboxes = [];
    List<double> newScores = [];

    (newClasses, newBboxes, newScores) = model.postprocess(
      inferenceOutput!.$1,
      inferenceOutput!.$2,
      inferenceOutput!.$3,
      confidenceThreshold: confidenceThreshold,
      iouThreshold: iouThreshold,
    );

    debugPrint('Detected ${bboxes.length} bboxes');
    setState(() {
      classes = newClasses;
      bboxes = newBboxes;
      scores = newScores;
    });
  }

  Future<void> pick(ImageSource source) async {
    // final PickedFile = await ImagePicker.pickImage(source: source);
    final XFile? newImageFile = await picker.pickImage(source: source);

    if (newImageFile != null) {
      setState(() {
        imageFile = File(newImageFile.path);
      });
      final image = img.decodeImage(await newImageFile.readAsBytes())!;
      imageWidth = image.width;
      imageHeight = image.height;
      inferenceOutput = model.infer(image);
      updatePostprocess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bboxesColors = List<Color>.generate(
      numClasses,
      (_) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    );

    final double displayWidth = MediaQuery.of(context).size.width;
    late double resizeFactor;

    if (imageWidth != null && imageHeight != null) {
      double k1 = displayWidth / imageWidth!;
      double k2 = maxImageWidgetHeight / imageHeight!;
      resizeFactor = max(k1, k2);
    }

    List<Bbox> getBboxesWidgets() {
      List<Bbox> bboxesWidgets = [];
      for (int i = 0; i < bboxes.length; i++) {
        final box = bboxes[i];
        final boxClass = classes[i];

        // Bbox é uma classe que tá no arquivo bbox
        bboxesWidgets.add(
          Bbox(
            box[0] * (displayWidth) * resizeFactor, // x
            box[1] * (maxImageWidgetHeight) * resizeFactor, // y
            box[2] * (displayWidth) * resizeFactor, // width
            box[3] * (maxImageWidgetHeight) * resizeFactor, // height
            labels[boxClass],
            scores[i],
            bboxesColors[boxClass],
          ),
        );
      }
      return bboxesWidgets;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('YOLO')),
      body: ListView(
        children: [
          SizedBox(
            height: maxImageWidgetHeight,
            child: Center(
              child: Stack(
                children: [
                  if (imageFile != null) Image.file(imageFile!),
                  // ...bboxesWidgets,
                  for (var widget in getBboxesWidgets()) widget
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          SizedBox(
            width: 30,
            height: 80,
            child: ElevatedButton(
              onPressed: () async {
                await pick(ImageSource.gallery);
              },
          
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(30, 120)),
          
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), 
                  ),
                ),
              ),
            
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined),
                  Text("Galeria"),
                ],
              ),
            ),
          ),
          
          const SizedBox(
            height: 20,
          ),

          SizedBox(
            width: 30,
            height: 80,
            child: ElevatedButton(
              onPressed: () async {
                await pick(ImageSource.gallery);
              },
          
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(30, 120)),
          
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), 
                  ),
                ),
              ),
            
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  Text("Galeria"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
