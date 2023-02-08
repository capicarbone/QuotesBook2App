import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/quotes_list_controller.dart';
import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatefulWidget {
  QuotesListScreen({required Key key}) : super(key: key);

  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  var _loadingQuotes = false;
  var _pageController = QuotesListController();

  // Allows to know when to ask the next quotes page
  static int _totalQuotes = 0;

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildList(context) {
    var lang = Localizations.localeOf(context).languageCode;

    if (!_pageController.hasListeners) {
      _pageController.addListener(() {
        if ((_pageController.page ?? 0) > _totalQuotes - 5 && !_loadingQuotes) {
          _fetchQuotes(lang);
        }
      });
    }

    return Consumer<Quotes>(
      builder: (context, provider, _) {
        return PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemBuilder: (ctx, position) {
            if (position == provider.quotes.length) {
              return Container(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                )),
                height: 80,
              );
            } else {
              var quote = provider.quotes[position];
              return QuoteListItem(
                  quote: quote,
                  onTap: () {
                    _pageController.animateToNextPage();
                  });
            }
          },
          itemCount: provider.quotes.length + 1,
        );
      },
    );
  }

  Future<void> _fetchQuotes(String lang) {
    _loadingQuotes = true;

    var promise =
        Provider.of<Quotes>(context, listen: false).fetchQuotes(lang: lang);

    promise.then((value) => _totalQuotes += value.length);

    promise.catchError((err) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).quotesLoadErrorMessage),
          duration: Duration(seconds: 20),
        ));
      });
    });

    promise.then((res) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });

    promise.whenComplete(() {
      _loadingQuotes = false;
    });

    return promise;
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<Quotes>(context, listen: false);
    var lang = Localizations.localeOf(context).languageCode;

    return (quotesProvider.quotes.length > 0)
        ? _buildList(context)
        : FutureBuilder(
            future: _fetchQuotes(lang),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey)));
              } else {
                return _buildList(context);
              }
            },
          );
  }
}
