import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatefulWidget {
  var lang;
  QuotesListScreen({Key key, @required this.lang}) : super(key: key);

  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  var _listController = ScrollController();
  var _loadingQuotes = false;
  Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    if (_initialLoad == null) {
      _initialLoad = _fetchQuotes();
    }
  }

  @override
  dispose() {
    super.dispose();
    _listController.dispose();
  }

  Widget _buildList(context) {
    if (!_listController.hasListeners) {
      _listController.addListener(() {
        if (_listController.position.pixels ==
                _listController.position.maxScrollExtent &&
            !_loadingQuotes) {
          _loadingQuotes = true;
          _fetchQuotes();
        }
      });
    }

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

  Future<void> _fetchQuotes() {
    return Provider.of<Quotes>(context, listen: false)
        .fetchQuotes(lang: widget.lang);
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<Quotes>(context, listen: false);

    return (quotesProvider.quotes.length > 0)
        ? _buildList(context)
        : FutureBuilder(
            future: _initialLoad,
            builder: (context, snapshot) {
              if (snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Some error has ocurred.')));
                });

                return Center(
                    child: Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      setState(() {
                        Scaffold.of(context).hideCurrentSnackBar();
                        _initialLoad = _fetchQuotes();
                      });
                    },
                  ),
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return _buildList(context);
              }
            },
          );
  }
}
