import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quotesbook/helpers/quotes_provider.dart';
import 'package:quotesbook/models/Quote.dart';

class Quotes with ChangeNotifier {
  final QuotesProvider _quotesProvider;

  Quotes(QuotesProvider quotesProvider) : _quotesProvider = quotesProvider;

  final List<Quote> _quoteList = [];
  List<Quote> _savedQuotes = [];

  get quotes {
    return _quoteList;
  }

  get savedQuotes {
    return _savedQuotes;
  }

  Future<List<Quote>> fetchQuotes({String lang = 'en'}) async {

    var newQuotes = await _quotesProvider.getQuotesSample(lang);

    _quoteList.addAll(newQuotes);

    notifyListeners();

    return newQuotes;
  }

  Future<void> saveQuote(Quote quote) async {
    quote.isFavorite = true;

    _quotesProvider.markAsFavorite(quote.id);
    _savedQuotes.add(quote);

    notifyListeners();
  }

  Future<void> removeQuote(Quote quote) async {
    quote.isFavorite = false;

    _quotesProvider.removeFromFavorites(quote.id);

    _savedQuotes.remove(quote);

    notifyListeners();
  }

  Future<void> loadSavedQuotes() async {
    if (_savedQuotes == null) {
      _savedQuotes = await _quotesProvider.getQuotes(isFavorite: true);

      notifyListeners();
    }
  }
}
