import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import 'TableNames.dart';

class DBHelper {
  static Future<void> _loadInitialData(sql.Database db) {
    db.insert(TableNames.quotes, {
      'id': '1',
      'body': 'Some inspirational quote.',
      'author_first_name': "Juan",
      'author_last_name': "Torres",
      'is_favorite': false,
    });

    db.insert(TableNames.quotes, {
      'id': '2',
      'body': 'May the force be with you.',
      'author_first_name': "Juan",
      'author_last_name': "Torres",
      'is_favorite': false,
    });

    db.insert(TableNames.quotes, {
      'id': '3',
      'body': 'Be water my friend.',
      'author_first_name': "Juan",
      'author_last_name': "Torres",
      'is_favorite': false,
    });
  }

  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'quotes.db'),
        onCreate: (sql.Database db, version) {
      db.execute(
          'CREATE TABLE ${TableNames.quotes}(id TEXT PRIMARY KEY, body TEXT, author_first_name TEXT, author_last_name TEXT, author_short_description TEXT, author_picture_url TEXT, theme_id TEXT, is_favorite BOOL)');

      _loadInitialData(db);
    }, version: 1);
  }
}
