import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/Quote.dart';
import '../models/Author.dart';

class DBHelper {

  static const _QUOTES_TABLE = 'quote';

  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'quotes.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $_QUOTES_TABLE(id TEXT PRIMARY KEY, body TEXT, author_first_name TEXT, author_last_name TEXT, author_short_description TEXT, author_picture_url TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.getDatabase();

    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertQuote(Quote quote) async {
    var quoteMap = {
      'id': quote.id,
      'body': quote.body,
      'author_first_name': quote.author.firstName,
      'author_last_name': quote.author.lastName,
      'author_short_description': quote.author.shortDescription,
      'author_picture_url': null,
    };

    await insert(_QUOTES_TABLE, quoteMap);
  }

  static Future<void> deleteQuote(Quote quote) async {
    final db = await DBHelper.getDatabase();

    await db.delete(_QUOTES_TABLE, where: 'id = ?', whereArgs: [quote.id]);

  }

  static Future<List<Map<String, dynamic>>> getdata(String table) async {
    final db = await getDatabase();
    return await db.query(table);
  }

  static Future<List<Quote>> getQuotes() async {
    var data = await getdata(_QUOTES_TABLE);

    List<Quote> quotes = data.map<Quote>( (map) {
      var author = Author(firstName: map['author_first_name'], lastName: map['author_last_name'], shortDescription: map['author_short_description'], pictureUrl: map['author_picture_url'] );
      var quote = Quote(author: author, body: map['body'], id: map['id'], isFavorite: true);
      return quote;
    }).toList();

    return quotes;
  }
}
