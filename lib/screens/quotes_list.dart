import 'package:flutter/material.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:provider/provider.dart';

import '../providers/quotes.dart';
import '../widgets/quote_listitem.dart';

class QuotesListScreen extends StatelessWidget {
  Widget _buildQuote(Quote quote) {
    return QuoteListItem(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: Provider.of<Quotes>(context, listen: false).fetchQuotes(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<Quotes>(
                  builder: (context, provider, _) => ListView.builder(
                    itemBuilder: (ctx, position) =>
                        _buildQuote(provider.quotes[position]),
                    itemCount: provider.quotes.length,
                  ),
                );
        },
      ),
    );
  }
}
