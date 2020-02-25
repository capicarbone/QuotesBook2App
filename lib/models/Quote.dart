import './Author.dart';

class Quote {
  String body;
  Author author;
  bool isFavorite;

  Quote({this.body, this.author, this.isFavorite = false});

  Quote.fromMap(Map<String, dynamic> map) {
    body = map['body'];
    author = Author(
        firstName: map['author']['first_name'],
        lastName: map['author']['last_name'],
        shortDescription: map['author']['short_description']);
    isFavorite = false;
  }
}
