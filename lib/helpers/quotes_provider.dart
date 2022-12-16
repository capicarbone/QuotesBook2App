
import 'package:quotesbook/helpers/TableNames.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Author.dart';
import '../models/Quote.dart';

class QuotesProvider {

  final Database _db;

  QuotesProvider({Database db}) : _db = db;

  List<Quote> _toEntities(List<Map> data) {
    return data.map<Quote>( (map) {
      var author = Author(firstName: map['author_first_name'], lastName: map['author_last_name'], shortDescription: map['author_short_description'], pictureUrl: map['author_picture_url'] );
      var quote = Quote(author: author, body: map['body'], id: map['id'], isFavorite: true, themeId: map['theme_id']);
      return quote;
    }).toList();
  }

  Future<List<Quote>> getQuotes({bool isFavorite}) async {

    var rawData = await _db.query(TableNames.quotes, where: 'is_favorite = ?', whereArgs: [isFavorite]);

    List<Quote> quotes = _toEntities(rawData);

    return quotes;
  }


  Future<void> insertQuote(Quote quote) async {
    var quoteMap = {
      'id': quote.id,
      'body': quote.body,
      'theme_id': quote.themeId,
      'author_first_name': quote.author.firstName,
      'author_last_name': quote.author.lastName,
      'author_short_description': quote.author.shortDescription,
      'author_picture_url': null,
    };

    await _db.insert(TableNames.quotes, quoteMap);
  }

  Future<void> deleteQuote(Quote quote) async {

    await _db.delete(TableNames.quotes, where: 'id = ?', whereArgs: [quote.id]);
  }

}