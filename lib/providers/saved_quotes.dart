import 'package:flutter/foundation.dart';
import 'package:quotesbook/helpers/quotes_provider.dart';

import '../helpers/db_helper.dart';
import '../models/Quote.dart';

class SavedQuotes extends ChangeNotifier {

  final QuotesProvider _quotesProvider;

  List<Quote> _savedQuotes;

  SavedQuotes(QuotesProvider quotesProvider) : _quotesProvider = quotesProvider;

  get savedQuotes {
    return _savedQuotes;
  }

  Future<void> loadSavedQuotes() async {
    if (_savedQuotes == null) {
      _savedQuotes = await _quotesProvider.getQuotes(isFavorite: true);

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

    _quotesProvider.insertQuote(quote);
    _savedQuotes.add(quote);

    notifyListeners();
  }

  Future<void> removeQuote(Quote quote) async {
    quote.isFavorite = false;

    _quotesProvider.deleteQuote(quote);

    _savedQuotes.remove(quote);

    notifyListeners();
  }
}
