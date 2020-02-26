import 'package:flutter/material.dart';
import '../models/Quote.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;

  QuoteListItem(this.quote);

  @override
  Widget build(BuildContext context) {
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
}
