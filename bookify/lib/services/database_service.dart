import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class DatabaseService {
  static Database? _database;
  static const String tableName = 'books';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'books.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        category TEXT NOT NULL,
        publishYear INTEGER NOT NULL,
        pageCount INTEGER NOT NULL,
        description TEXT NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        readingProgress INTEGER NOT NULL DEFAULT 0,
        addedDate INTEGER NOT NULL
      )
    ''');
  }

  static Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(tableName, book.toMap());
  }

  static Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  static Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }

  static Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      tableName,
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  static Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Book>> searchBooks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  static Future<List<Book>> getBooksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  static Future<List<Book>> getFavoriteBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }
}
