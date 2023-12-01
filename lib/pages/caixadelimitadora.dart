import 'dart:io';
import 'dart:typed_data';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;

void box() {
  // Carregar uma imagem de exemplo (substitua pelo seu caminho de imagem)
  File file = File(
      '/data/user/0/com.example.yolo_tflite/cache/0d0ae3ab-9f36-4c64-9566-70096d757d67/1000067012.jpg');
  List<int> bytes = file.readAsBytesSync();
  img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

  // Definir as coordenadas da caixa delimitadora
  int xMin = 661;
  int yMin = 661;
  int xMax = 1199;
  int yMax = 1198;

  // Definir a cor da caixa delimitadora (vermelho no formato ARGB)
  img.ColorRgb8 boxColor = img.ColorRgb8(250, 0, 0);

  // Desenhar a caixa delimitadora na imagem
  drawBoundingBox(image!, xMin, yMin, xMax, yMax, boxColor);

  // Salvar a imagem resultante
  // File output = File('caminho/para/saida/imagem_com_caixa.jpg');
  File output = File('/data/user/0/com.example.yolo_tflite/cache/0d0ae3ab-9f36-4c64-9566-70096d757d67/1000067012.jpg');
  output.writeAsBytesSync(img.encodeJpg(image));
  // saveImage(File(img.encodeJpg(image).toString()));
}

saveImage(File imge) async {
  File imageFile;
  imageFile = File(imge.path);
  print("Image file $imageFile");
  GallerySaver.saveImage(imge.path, albumName: "mediaPred");
}

void drawBoundingBox(
    img.Image image, int xMin, int yMin, int xMax, int yMax, img.ColorRgb8 color) {
  // Garantir que as coordenadas estejam dentro dos limites da imagem
  xMin = xMin.clamp(0, image.width - 1);
  yMin = yMin.clamp(0, image.height - 1);
  xMax = xMax.clamp(0, image.width - 1);
  yMax = yMax.clamp(0, image.height - 1);

  

  // print(img.fillRect(image,
  // x1: 100, y1: 200, x2: 100, y2: 200, color: Color.fromARGB(0, 255, 0, 0)));

  // Desenhar as linhas horizontais da caixa delimitadora
  for (int x = xMin; x <= xMax; x++) {
    image.setPixel(x, yMin, color);
    image.setPixel(x, yMax, color);
  }

  // Desenhar as linhas verticais da caixa delimitadora
  for (int y = yMin; y <= yMax; y++) {
    image.setPixel(xMin, y, color);
    image.setPixel(xMax, y, color);
  }
}
