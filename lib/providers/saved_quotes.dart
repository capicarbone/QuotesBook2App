import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../models/Quote.dart';

class SavedQuotes extends ChangeNotifier {
  List<Quote> _savedQuotes;

  get savedQuotes {
    return _savedQuotes;
  }

  Future<void> loadSavedQuotes() async {
    if (_savedQuotes == null) {
      _savedQuotes = await DBHelper.getQuotes();

      notifyListeners();
    }  
  }

  Quote getQuote(String id) {
    return _savedQuotes.firstWhere((item) => item.id == id);
  }

  bool isSaved(String id) {
    return _savedQuotes.map((e) => e.id).toList().contains(id);
  }

  Future<void> saveQuote(Quote quote) async {
    quote.isFavorite = true;

    DBHelper.insertQuote(quote);
    _savedQuotes.add(quote);

    notifyListeners();
  }

  Future<void> removeQuote(Quote quote) async {
    quote.isFavorite = false;

    DBHelper.deleteQuote(quote);

    _savedQuotes.remove(quote);

    notifyListeners();
  }
}
