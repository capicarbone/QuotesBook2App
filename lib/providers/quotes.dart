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

  set savedQuotes(List<Quote> savedQuotes) {
    _savedQuotes = savedQuotes;

    if (savedQuotes != null) {
      _quoteList.forEach((quote) {
        quote.isFavorite = _savedQuotes.firstWhere(
                (savedQuote) => savedQuote.id == quote.id,
                orElse: () => null) !=
            null;
      });
    }

    notifyListeners();
  }

  final _authenticatedHeader = {
    'Authorization': 'Token ${dotenv.env['AUTH_TOKEN']}'
  };

  Future<List<Quote>> fetchQuotes({String lang = 'en'}) async {

    var newQuotes = await _quotesProvider.getQuotes(isFavorite: false);

    _quoteList.addAll(newQuotes);

    notifyListeners();

    return newQuotes;
  }
}
