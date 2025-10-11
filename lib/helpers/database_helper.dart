import 'dart:io';
import 'package:hackatonapp/models/evento.dart';
import 'package:hackatonapp/models/sintoma.dart';
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
    return await openDatabase(path, version: 3, onCreate: _createDb, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE eventos ADD COLUMN classificationResult TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE eventos ADD COLUMN tieneFactorRiesgo INTEGER NOT NULL DEFAULT 0');
      // In a real migration, you would want to be more careful here.
      // For now, we just rename the column for future installations.
      // We will assume existing data can be lost or is not critical.
      await db.execute('ALTER TABLE eventos RENAME COLUMN classificationResult TO classification');
    }
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
        classification TEXT NOT NULL,
        tieneFactorRiesgo INTEGER NOT NULL,
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
        pregunta TEXT NOT NULL,
        category TEXT NOT NULL
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

  // User methods
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

  // Ubicacion methods
  Future<int> insertUbicacion(Ubicacion ubicacion) async {
    final db = await instance.database;
    return await db.insert('ubicaciones', ubicacion.toMap());
  }

  // Antecedente methods
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
  
  // Evento methods
  Future<Evento> insertEvento(Evento evento, Map<int, bool> answers) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      int eventoId = await txn.insert('eventos', evento.toMap());
      evento = Evento(
        id: eventoId,
        usuarioId: evento.usuarioId,
        ubicacionId: evento.ubicacionId,
        fecha: evento.fecha,
        sintomas: evento.sintomas,
        documento_persona: evento.documento_persona,
        es_usuario_principal: evento.es_usuario_principal,
        parentesco: evento.parentesco,
        classification: evento.classification,
        tieneFactorRiesgo: evento.tieneFactorRiesgo,
      );

      for (var sintoma in evento.sintomas) {
        await txn.insert('evento_sintomas', {
          'eventoId': eventoId,
          'sintomaId': sintoma.id,
          'respuesta': answers[sintoma.id] == true ? 1 : 0,
        });
      }
    });
    return evento;
  }

  Future<List<Evento>> getEventos(int usuarioId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('eventos', where: 'usuarioId = ?', whereArgs: [usuarioId]);

    List<Evento> eventos = [];
    for (var map in maps) {
      final evento = Evento.fromMap(map);
      final List<Map<String, dynamic>> sintomasMap = await db.rawQuery('''
        SELECT s.* FROM sintomas s
        INNER JOIN evento_sintomas es ON s.id = es.sintomaId
        WHERE es.eventoId = ? AND es.respuesta = 1
      ''', [evento.id]);

      final sintomas = sintomasMap.map((s) => Sintoma.fromMap(s)).toList();
      eventos.add(Evento(
        id: evento.id,
        usuarioId: evento.usuarioId,
        ubicacionId: evento.ubicacionId,
        fecha: evento.fecha,
        sintomas: sintomas,
        documento_persona: evento.documento_persona,
        es_usuario_principal: evento.es_usuario_principal,
        parentesco: evento.parentesco,
        classification: evento.classification,
        tieneFactorRiesgo: evento.tieneFactorRiesgo,
      ));
    }
    return eventos;
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
