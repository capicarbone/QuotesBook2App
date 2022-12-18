import 'package:quotesbook/helpers/TableNames.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Author.dart';
import '../models/Quote.dart';

class QuotesProvider {
  final Database _db;

  QuotesProvider({Database db}) : _db = db;

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
          isFavorite: true,
          themeId: map['theme_id']);
      return quote;
    }).toList();
  }

  Future<List<Quote>> getQuotes({bool isFavorite}) async {
    var rawData = await _db.query(TableNames.quotes,
        where: 'is_favorite = ?', whereArgs: [isFavorite]);

    List<Quote> quotes = _toEntities(rawData);

    return quotes;
  }

  Future<void> markAsFavorite(String quoteId) async {
    await _db.update(TableNames.quotes, {'is_favorite': true},
        where: 'id = ? ', whereArgs: [quoteId]);
  }

  Future<void> removeFromFavorites(String quoteId) async {
    await _db.update(TableNames.quotes, {'is_favorite': false},
        where: 'id = ? ', whereArgs: [quoteId]);
  }
}
