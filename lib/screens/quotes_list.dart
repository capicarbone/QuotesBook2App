import 'package:flutter/material.dart';
import 'package:quotesbook/models/Author.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:provider/provider.dart';

import '../providers/quotes.dart';

class QuotesListScreen extends StatelessWidget {
  var _testQuotes = [
    Quote(
      body:
          "Beauty is worse than wine, it intoxicates both the holder and beholder.",
      author: Author(
          firstName: "Aldous",
          lastName: "Huxley",
          shortDescription: "American novelist"),
    ),
    Quote(
      body: "Evil is not something superhuman, it's something less than human.",
      author: Author(
          firstName: "Agatha",
          lastName: "Christie",
          shortDescription: "American novelist"),
    ),
  ];

  Widget _buildQuote(BuildContext context, int position) {
    Quote quote = _testQuotes[position];

    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                quote.body,
                style: TextStyle(fontSize: 16),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    Text(
                        '- ${quote.author.firstName} ${quote.author.lastName}'),
                    Text(quote.author.shortDescription,
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
                  : ListView.builder(
                      itemBuilder: _buildQuote,
                      itemCount: _testQuotes.length,
                    ),
        ));
  }
}
