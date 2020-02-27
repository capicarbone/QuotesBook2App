import 'package:flutter/material.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:provider/provider.dart';

import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatefulWidget {
  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  var _listController = ScrollController();
  var _loadingQuotes = false;

  @override
  void initState() {
    super.initState();
    _listController.addListener(() {
      if (_listController.position.pixels ==
              _listController.position.maxScrollExtent &&
          !_loadingQuotes) {
        _loadingQuotes = true;
        Provider.of<Quotes>(context, listen: false).fetchQuotes();
      }
    });
  }

  Widget _buildQuote(Quote quote) {
    return QuoteListItem(quote);
  }

  Widget _buildList(context, quotes) {
    return ListView.builder(
      controller: _listController,
      itemBuilder: (ctx, position) {
        _loadingQuotes = false;

        if (position == quotes.length) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
            height: 80,
          );
        } else {
          return _buildQuote(quotes[position]);
        }
      },
      itemCount: quotes.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: Provider.of<Quotes>(context, listen: false).fetchQuotes(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<Quotes>(
                    builder: (context, provider, _) =>
                        _buildList(context, provider.quotes)),
      ),
    );
  }
}
