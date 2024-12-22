import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQlHelperNotification {
  static Database? _database;

  // الوصول لقاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            user_name TEXT,
            user_email TEXT,
            photoUrl TEXT,
            timestamp TEXT
          )
        ''');
        log('Table notifications created');
      },
    );
  }

  // إدخال إشعار
  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return await db.insert('notifications', notification);
  }

  // جلب جميع الإشعارات
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('notifications');
  }

  // حذف إشعار واحد باستخدام المعرف (id)
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// حذف جميع الإشعارات
  Future<int> deleteAllNotifications() async {
    final db = await database;
    return await db.delete('notifications');
  }
}
