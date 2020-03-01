import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/providers/quotes.dart';
import 'package:quotesbook/widgets/quote_listitem.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Quotes>(
      builder: (ctx, provider, _) => ListView.builder(
        itemCount: (provider != null) ? provider.savedQuotes.length : 0,
        itemBuilder: (context, index) =>
            QuoteListItem(provider.savedQuotes[index]),
      ),
    );
  }
}
