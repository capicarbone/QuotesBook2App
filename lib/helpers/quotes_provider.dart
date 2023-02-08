import 'package:quotesbook/helpers/TableNames.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Author.dart';
import '../models/Quote.dart';

class QuotesProvider {
  final Database _db;

  QuotesProvider({required Database db}) : _db = db;

  List<Quote> _toEntities(List<Map> data) {
    return data.map<Quote>((map) {
      var author = Author(
          firstName: map['author_first_name'],
          lastName: map['author_last_name'],
          shortDescription: map['author_short_description'],
          pictureUrl: map['author_picture_url']);
      var quote = Quote(
          author: author,
          body: map['body'],
          id: map['id'],
          isFavorite: map['is_favorite'] != 0,
          themeId: map['theme_id']);
      return quote;
    }).toList();
  }

  Future<List<Quote>> getQuotes({bool isFavorite = false}) async {
    var rawData = await _db.query(TableNames.quotes,
        where: 'is_favorite = ?', whereArgs: [isFavorite]);

    List<Quote> quotes = _toEntities(rawData);

    return quotes;
  }

  Future<List<Quote>> getQuotesSample(String lang, {count = 20}) async {
    var ids = await _db.query(TableNames.quotes,
        where: 'lang = ? AND is_favorite = ?',
        whereArgs: [lang, 0],
        columns: ['id']);

    ids = ids.toList(growable: true)..shuffle();

    List<String> selectedIds =
        ids.sublist(0, count).map((e) => e['id'].toString()).toList();

    String idsStr =
        selectedIds.reduce((value, element) => value += "$element,");
    idsStr = idsStr.substring(0, idsStr.length - 1);

    var rawData = await _db
        .rawQuery("SELECT * FROM ${TableNames.quotes} WHERE id IN ($idsStr)");

    List<Quote> quotes = _toEntities(rawData);

    return quotes;
  }

  Future<void> markAsFavorite(int quoteId) async {
    await _db.update(TableNames.quotes, {'is_favorite': true},
        where: 'id = ? ', whereArgs: [quoteId]);
  }

  Future<void> removeFromFavorites(int quoteId) async {
    await _db.update(TableNames.quotes, {'is_favorite': false},
        where: 'id = ? ', whereArgs: [quoteId]);
  }
}
