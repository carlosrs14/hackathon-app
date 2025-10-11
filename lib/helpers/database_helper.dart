
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


import 'package:hackatonapp/models/antecedente.dart';
import 'package:hackatonapp/models/ubicacion.dart';
import 'package:hackatonapp/models/usuario.dart';

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
        cedula TEXT NOT NULL UNIQUE,
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
        documento_persona TEXT NOT NULL,
        es_usuario_principal INTEGER NOT NULL,
        parentesco TEXT,
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

  Future<int> insertUser(Usuario usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> getUser() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios', limit: 1);

    if (maps.isNotEmpty) {
      return Usuario(
        id: maps[0]['id'],
        cedula: maps[0]['cedula'],
        edad: maps[0]['edad'],
      );
    }
    return null;
  }

  Future<int> insertUbicacion(Ubicacion ubicacion) async {
    final db = await instance.database;
    return await db.insert('ubicaciones', ubicacion.toMap());
  }

  Future<int> insertAntecedente(Antecedente antecedente) async {
    final db = await instance.database;
    return await db.insert('antecedentes', antecedente.toMap());
  }

  Future<List<Antecedente>> getAntecedentes(int usuarioId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('antecedentes', where: 'usuarioId = ?', whereArgs: [usuarioId]);

    return List.generate(maps.length, (i) {
      return Antecedente.fromMap(maps[i]);
    });
  }

  Future<int> updateAntecedente(Antecedente antecedente) async {
    final db = await instance.database;
    return await db.update(
      'antecedentes',
      antecedente.toMap(),
      where: 'id = ?',
      whereArgs: [antecedente.id],
    );
  }

  Future<int> deleteAntecedente(int id) async {
    final db = await instance.database;
    return await db.delete(
      'antecedentes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, List<Map<String, dynamic>>>> getAllData() async {
    final db = await instance.database;
    final tables = ['usuarios', 'ubicaciones', 'tipos_evento', 'eventos', 'antecedentes', 'sintomas', 'evento_sintomas'];
    final Map<String, List<Map<String, dynamic>>> allData = {};

    for (final table in tables) {
      final List<Map<String, dynamic>> maps = await db.query(table);
      allData[table] = maps;
    }

    return allData;
  }
}
