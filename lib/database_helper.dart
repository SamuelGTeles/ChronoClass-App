import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chrono_class.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
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
        password TEXT,
        role TEXT NOT NULL DEFAULT 'student',
        class_team TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        teacher TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE personal_tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        priority TEXT NOT NULL,
        completed BOOLEAN NOT NULL DEFAULT 0,
        created_by INTEGER NOT NULL
      )
    ''');

    // Inserir matérias padrão
    await _insertDefaultSubjects(db);
  }

  Future<void> _insertDefaultSubjects(Database db) async {
    final subjects = [
      {'name': 'Alemão', 'teacher': 'Michele'},
      {'name': 'Educação Física', 'teacher': 'Alexandre'},
      {'name': 'Arte', 'teacher': 'Felipe'},
      {'name': 'Química', 'teacher': 'Sandra'},
      {'name': 'Biologia', 'teacher': 'Fernando'},
      {'name': 'Geografia', 'teacher': 'Wallacy'},
      {'name': 'História', 'teacher': 'Giovanni'},
      {'name': 'Administração de Servidores', 'teacher': 'João Paulo'},
      {'name': 'Horário de Estudo', 'teacher': 'Rebeca'},
      {'name': 'Redação', 'teacher': 'Clariany'},
      {'name': 'Português', 'teacher': 'Rafael'},
      {'name': 'Sociologia', 'teacher': 'Washington'},
      {'name': 'Segurança de Redes de Computadores', 'teacher': 'Davidson'},
      {'name': 'Espanhol', 'teacher': 'Denise'},
      {'name': 'Física', 'teacher': 'Romário'},
      {'name': 'Formação Cidadã', 'teacher': 'Felipe'},
      {'name': 'Gestão de Startups II', 'teacher': 'Davidson'},
      {'name': 'Mundo do Trabalho', 'teacher': 'Rebeca'},
      {'name': 'Inglês', 'teacher': 'Rebeca'},
      {'name': 'Filosofia', 'teacher': 'Washington'},
      {'name': 'Cabeamento Estruturado', 'teacher': 'João Paulo'},
      {'name': 'Matemática e Projeto Interdisciplinar', 'teacher': 'Luan'},
      {'name': 'Gerência de Projetos', 'teacher': 'Davidson'},
      {'name': 'Projeto de Vida', 'teacher': 'Silvia'},
    ];

    for (var subject in subjects) {
      await db.insert('subjects', subject);
    }
  }

  Future<void> _createAdminUser(Database db) async {
    final result = await db.query('users', where: 'username = ?', whereArgs: ['admin']);
    if (result.isEmpty) {
      await db.insert('users', {
        'username': 'admin',
        'password': '1234',
        'role': 'admin',
        'class_team': 'Redes de Computadores II'
      });
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> register(String username, String password, String role) async {
    try {
      final db = await database;
      await db.insert('users', {
        'username': username,
        'password': password,
        'role': role,
        'class_team': 'Redes de Computadores II'
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final db = await database;
    return await db.query('subjects');
  }

  Future<List<Map<String, dynamic>>> getPersonalTasks(int userId) async {
    final db = await database;
    return await db.query('personal_tasks', 
      where: 'created_by = ?', 
      whereArgs: [userId],
      orderBy: 'completed ASC, id DESC'
    );
  }

  Future<int> insertPersonalTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('personal_tasks', task);
  }

  Future<int> updatePersonalTask(int taskId, bool completed) async {
    final db = await database;
    return await db.update('personal_tasks', 
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId]
    );
  }
}