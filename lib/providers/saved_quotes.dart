import 'package:flutter/foundation.dart';
import 'package:quotesbook/helpers/quotes_provider.dart';

import '../helpers/db_helper.dart';
import '../models/Quote.dart';

@Deprecated("About to be removed")
class SavedQuotes extends ChangeNotifier {

  final QuotesProvider _quotesProvider;

  List<Quote> _savedQuotes = [];

  SavedQuotes(QuotesProvider quotesProvider) : _quotesProvider = quotesProvider;

  get savedQuotes {
    return _savedQuotes;
  }

  Quote getQuote(String id) {
    return _savedQuotes.firstWhere((item) => item.id == id);
  }

  bool isSaved(String id) {
    return _savedQuotes.map((e) => e.id).toList().contains(id);
  }


}
