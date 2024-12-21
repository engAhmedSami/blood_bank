import 'dart:developer';
import 'dart:io';

import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/models/health_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQlHelperHealthRequest {
  static Database? _database;

  // Access the database (create it if it doesn't exist)
  Future<Database> get database async {
    if (_database != null) {
      log('Returning existing database');
      return _database!;
    }
    // Initialize the database if not created yet
    log('Creating new database');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    log('Initializing database...');
    try {
      // Get the directory for storing the database file
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path,
          'notes.db'); // Change 'notes.db' to your db name
      log('Database path: $path');

      // Ensure the directory exists
      await Directory(documentsDirectory.path).create(recursive: true);
      log('Directory created at: ${documentsDirectory.path}');

      // Open the database
      var db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          log('Database opened successfully');
        },
      );

      log('Database initialized successfully');
      return db;
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  // Initialize the database
  // Create the table if it doesn't exist
  Future _onCreate(Database db, int version) async {
    log('Creating table "articles" in the database');
    await db.execute('''
      CREATE TABLE articles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        content TEXT,
        image TEXT,
        url TEXT,
        publishedAt TEXT,
        sourceName TEXT,
        sourceUrl TEXT
      )
    ''');
    log('Table "articles" created successfully');
  }

  // Insert an article into the database
  Future<int> insertArticle(HealthModel article) async {
    final db = await database;
    log('Inserting article into database: ${article.title}');
    int result = await db.insert('articles', article.toMap());
    log('Inserted article with id: $result');
    return result;
  }

  // Fetch all articles from the database
  Future<List<HealthModel>> getAllArticles() async {
    final db = await database;
    log('Fetching all articles from database');
    final List<Map<String, dynamic>> maps = await db.query('articles');
    log('Fetched ${maps.length} articles');

    // Return a list of HealthModel instances from the fetched data
    return List.generate(maps.length, (i) {
      log('Converting map to HealthModel for article ${i + 1}');
      return HealthModel.fromMap(maps[i]);
    });
  }
}
