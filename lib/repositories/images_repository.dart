import 'package:sqflite/sqflite.dart';
import 'package:yolo_flutter/database/db.dart';

class ImageRepository {
  late Database db;

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

  void deleteDatabase() async {
    final Database db = await DB.instance.database;
  // Obter o diretório do aplicativo para armazenar o banco de dados
    // String databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'dbimages.db');

    // Excluir o banco de dados se existir
    // await deleteDatabase();
    db.execute('DROP TABLE IF EXISTS dadosimages');
  }

  void deleteValsTable() async{
    final Database db = await DB.instance.database;
    await db.delete('dadosimages');
  }
}


void main() {
  // ImageRepository a = ImageRepository();
  // print(a.getAllItems());
}
