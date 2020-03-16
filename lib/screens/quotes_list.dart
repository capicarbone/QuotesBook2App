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
  var _automaticReloadEnabled = false;
  var _elapsedErrors = 0;
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
        if (_listController.position.pixels >=
                _listController.position.maxScrollExtent - 200 &&
            !_loadingQuotes) {          
          _fetchQuotes();
        }
      });
    }

    return Consumer<Quotes>(
      builder: (context, provider, _) => ListView.builder(
        controller: _listController,
        itemBuilder: (ctx, position) {
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
    var promise = Provider.of<Quotes>(context, listen: false)
        .fetchQuotes(lang: widget.lang);

    _loadingQuotes = true;

    promise.catchError((err) {
      if (_elapsedErrors == 0) {
        Scaffold.of(context).hideCurrentSnackBar();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scaffold.of(context)
              .showSnackBar( _automaticReloadEnabled ? SnackBar(content: Text('Some error has ocurred. Trying again.'), duration: Duration(seconds: 20),) :  SnackBar(content: Text('Some error has ocurred.')));
        });
      }

      if (_automaticReloadEnabled) {
        Timer(Duration(seconds: 3), _fetchQuotes);
      }

      _elapsedErrors++;
    });


    promise.then((res) {
      Scaffold.of(context).hideCurrentSnackBar();
      _elapsedErrors = 0;
    });

    promise.whenComplete(() {
      _loadingQuotes = false;
    });

    return promise;
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
                        _initialLoad = _fetchQuotes();
                      });
                    },
                  ),
                ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                _automaticReloadEnabled = true;
                return _buildList(context);
              }
            },
          );
  }
}
