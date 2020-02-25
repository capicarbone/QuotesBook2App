
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:http/http.dart' as http;

class Quotes with ChangeNotifier {

  final List<Quote> _quotes = [];

  get quotes {
    return _quotes;
  }

  final _authenticatedHeader = {
      'Authorization': 'Token 9598020bb81bf271c7105c9b057823b62463eae2'
    };

  Future<void> fetchQuotes() async  {
    
    var response = await http.get("https://quotesbook.herokuapp.com/api/v1/quotes/sample", headers: _authenticatedHeader );    

    List<dynamic> quotesMap = json.decode(response.body);

    //print(quotesMap);

    _quotes.addAll( quotesMap.map( (map) => Quote.fromMap(map) ) );
    
  }
}