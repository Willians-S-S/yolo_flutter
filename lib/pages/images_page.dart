import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:yolo_flutter/repositories/images_repository.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  List<Widget> images = [];

  List<Widget> setListView() {
    // Criar uma cópia da lista para que a mudança seja detectada pelo Flutter
    List<Widget> copiaLista = List.from(images);
    return copiaLista;
  }

  Future<void> loadImageData() async {
    ImageRepository imges = ImageRepository();
    List<Map<String, dynamic>> imageData = await imges.getAllItems();

    for (Map<String, dynamic> imageInfo in imageData) {
      final Image image = Image.file(File(imageInfo['caminho_imagem']));
      final Text text = Text(
        imageInfo["classe"],
        style: const TextStyle(
          color: Colors.red,
        ),
      );

      setState(() {
        images.add(Stack(
          children: [
            image,
            text,
          ],
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de imagens"),
        ),
        body: ListView(children: setListView()));
  }
}
