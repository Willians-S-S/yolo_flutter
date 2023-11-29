import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{
  // Construtor com acesso privado
  DB._();
  // Criar uma instancia de DB
  static final DB instance = DB._();
  //Instancia do SQLite
  static Database? _database;


  // Esse método retorna o banco de dados se ele já foi iniciado
  // se não ele inicia
  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  // Essa função inicia o db
  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dbimages.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(images);
  }

  String get images => '''
    CREATE TABLE dadosimages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      caminho_imagem TEXT,
      classe TEXT
    );
  ''';
}