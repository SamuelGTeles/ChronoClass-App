import 'dart:io' show Platform;
import 'package:path/path.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Detecta o ambiente e usa o tipo correto de banco
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      databaseFactory = databaseFactory;
    }

    // Caminho do banco de dados
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'chrono_class.db');

    final db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );

    await _createAdminUser(db);
    _database = db;
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<void> _createAdminUser(Database db) async {
    final result =
        await db.query('users', where: 'username = ?', whereArgs: ['admin']);
    if (result.isEmpty) {
      await db.insert('users', {'username': 'admin', 'password': '1234'});
      print('✅ Usuário admin criado com sucesso');
    }
  }

  Future<bool> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<bool> register(String username, String password) async {
    try {
      final db = await database;
      await db.insert('users', {'username': username, 'password': password});
      return true;
    } catch (e) {
      print('Erro ao registrar: $e');
      return false;
    }
  }
}
