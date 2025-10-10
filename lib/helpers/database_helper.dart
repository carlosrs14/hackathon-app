
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'hackatonapp.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        edad INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ubicaciones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        departamento TEXT NOT NULL,
        municipio TEXT NOT NULL,
        latitud REAL,
        longitud REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE tipos_evento(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE eventos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        tipoEventoId INTEGER,
        ubicacionId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuarios(id),
        FOREIGN KEY (tipoEventoId) REFERENCES tipos_evento(id),
        FOREIGN KEY (ubicacionId) REFERENCES ubicaciones(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE antecedentes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuarios(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sintomas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        pregunta TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE evento_sintomas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        eventoId INTEGER NOT NULL,
        sintomaId INTEGER NOT NULL,
        respuesta INTEGER NOT NULL, -- 1 for true (yes), 0 for false (no)
        FOREIGN KEY (eventoId) REFERENCES eventos(id),
        FOREIGN KEY (sintomaId) REFERENCES sintomas(id)
      )
    ''');
  }
}
