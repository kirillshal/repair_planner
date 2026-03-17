import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/room.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'repair_planner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rooms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        length REAL NOT NULL,
        width REAL NOT NULL,
        materialType TEXT NOT NULL,
        wastePercentage REAL NOT NULL,
        calculatedArea REAL NOT NULL,
        tilesNeeded INTEGER,
        laminateNeeded REAL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRoom(Room room) async {
    Database db = await database;
    return await db.insert('rooms', room.toMap());
  }

  Future<List<Room>> getAllRooms() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rooms',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) {
      return Room.fromMap(maps[i]);
    });
  }

  Future<Room?> getRoomById(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rooms',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Room.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteRoom(int id) async {
    Database db = await database;
    return await db.delete(
      'rooms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}