import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:quotesbook/data/quotes_data.dart' as fixedData;

import 'TableNames.dart';

class DBHelper {
  static Future<void> _loadInitialData(sql.Database db) {

    fixedData.quotes.forEach((q) {
      db.insert(TableNames.quotes, {
        'body': q['body'],
        'author_first_name': q['author_first_name'],
        'author_last_name': q['author_last_name'],
        'is_favorite': false,
        'lang': q['lang']
      });
    });
  }

  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'quotes.db'),
        onCreate: (sql.Database db, version) {
      db.execute(
          '''CREATE TABLE ${TableNames.quotes}(
          id INTEGER PRIMARY KEY, 
          body TEXT, author_first_name TEXT, 
          author_last_name TEXT,
          lang TEXT 
          author_short_description TEXT, 
          author_picture_url TEXT, 
          theme_id TEXT, 
          is_favorite BOOL)'''
      );

      _loadInitialData(db);

      ;
    }, version: 1);
  }
}
