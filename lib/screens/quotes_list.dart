import 'package:flutter/material.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:provider/provider.dart';

import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatefulWidget {
  QuotesListScreen({Key key}) : super(key: key);

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

  Widget _buildList(context) {
    return Consumer<Quotes>(
      builder: (context, provider, _) => ListView.builder(
        controller: _listController,
        itemBuilder: (ctx, position) {
          _loadingQuotes = false;

          if (position == provider.quotes.length) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              height: 80,
            );
          } else {
            return QuoteListItem(provider.quotes[position]);
          }
        },
        itemCount: provider.quotes.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<Quotes>(context, listen: false);

    return (quotesProvider.quotes.length > 0)
        ? _buildList(context)
        : FutureBuilder(
            future: Provider.of<Quotes>(context, listen: false).fetchQuotes(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : _buildList(context),
          );
  }
}
