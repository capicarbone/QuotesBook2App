import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Quote.dart';
import '../providers/quotes.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;

  QuoteListItem(this.quote);

  @override
  Widget build(BuildContext context) {

    var quotesProvider = Provider.of<Quotes>(context, listen: false);

    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(
                  quote.body,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '- ${quote.author.firstName} ${quote.author.lastName}',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      quote.author.shortDescription,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.star,
                              color:
                                  quote.isFavorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () {
                              if (quote.isFavorite){
                                quotesProvider.removeQuote(quote);
                              }else {
                                quotesProvider.saveQuote(quote);
                              }
                              
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
