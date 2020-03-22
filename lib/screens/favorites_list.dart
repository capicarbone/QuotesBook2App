import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/widgets/quote_listitem.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    Provider.of<SavedQuotes>(context, listen: false).loadSavedQuotes();

    return Consumer<SavedQuotes>(
      builder: (ctx, provider, _) => provider.savedQuotes == null ||
              provider.savedQuotes.length == 0
          ? Center(
              child: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context).favoritesEmptyMessage, style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 12,),
                  Icon(Icons.star, color: Colors.grey, size: 48,)
                ],
              ),
            ))
          : ListView.builder(
              itemCount: (provider != null) ? provider.savedQuotes.length : 0,
              itemBuilder: (context, index) =>
                  QuoteListItem(provider.savedQuotes[index]),
            ),
    );
  }
}
