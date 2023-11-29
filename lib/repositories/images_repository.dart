import 'package:sqflite/sqflite.dart';
import 'package:yolo_flutter/database/db.dart';

class ImageRepository {
  late Database db;

  // setSaldo(double valor) async {
  //   db = await DB.instance.database;

  //   db.update('dados_images', {
  //     'saldo': valor,
  //   });
  // }

  setImage(String caminho, String classe) async {
    db = await DB.instance.database;
    db.update('dadosimages', {"caminho_imagem": caminho, "classe": classe});
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await DB.instance.database;
    return await db.query('dadosimages');
  }


  Future<void> insertData(String caminho, String classe) async {
    // Obtenha uma referência ao banco de dados
    final Database db = await DB.instance.database;

    // Execute a operação de INSERT
    await db.insert(
      'dadosimages',
      {'caminho_imagem': caminho, "classe": classe},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}

void main() {
  // ImageRepository a = ImageRepository();
  // print(a.getAllItems());
}
