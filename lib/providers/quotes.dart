import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:http/http.dart' as http;

class Quotes with ChangeNotifier {
  final List<Quote> _quotes = [];
  List<Quote> _savedQuotes = [];

  static const SERVER_HOST = "https://quotesbook.herokuapp.com/";

  get quotes {
    return _quotes;
  }

  set savedQuotes(List<Quote> savedQuotes) {
    _savedQuotes = savedQuotes;

    if (savedQuotes != null) {
      _quotes.forEach((quote) {
        quote.isFavorite = _savedQuotes.firstWhere(
                (savedQuote) => savedQuote.id == quote.id,
                orElse: () => null) !=
            null;
      });
    }
    
    notifyListeners();
  }

  final _authenticatedHeader = {
    'Authorization': 'Token 9598020bb81bf271c7105c9b057823b62463eae2'
  };

  Future<List<Quote>> fetchQuotes({String lang = 'en'}) async {
    lang = lang == 'es' ? lang : 'en';
    final url = "${SERVER_HOST}api/v1/quotes/sample?lang=$lang";

    print(url);

    var response = await http.get(url, headers: _authenticatedHeader);

    List<dynamic> quotesMap = json.decode(response.body);

    //print(quotesMap);

    var newQuotes = quotesMap.map((map) => Quote.fromMap(map)).toList();
    _quotes.addAll(newQuotes);

    notifyListeners();

    return newQuotes;

  }
}
