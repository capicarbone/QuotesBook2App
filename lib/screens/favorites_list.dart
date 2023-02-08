import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/quotes_list_controller.dart';
import 'package:quotesbook/widgets/quote_listitem.dart';

import '../providers/quotes.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({required Key key}) : super(key: key);
  var _pageController = QuotesListController();

  @override
  Widget build(BuildContext context) {

    return Consumer<Quotes>(
      builder: (ctx, provider, _) => provider.savedQuotes == null ||
              provider.savedQuotes.length == 0
          ? Center(
              child: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).favoritesEmptyMessage,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Icon(
                    Icons.bookmark,
                    color: Colors.grey,
                    size: 48,
                  )
                ],
              ),
            ))
          : PageView.builder(
              itemCount: (provider != null) ? provider.savedQuotes.length : 0,
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemBuilder: (context, index) => QuoteListItem(
                  quote: provider.savedQuotes[index],
                  onTap: () {
                    _pageController.animateToNextPage();
                  }),
            ),
    );
  }
}
