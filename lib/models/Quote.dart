import './Author.dart';

class Quote {
  int id;
  String body;
  Author author;
  bool isFavorite;
  String themeId;

  Quote({this.id, this.body, this.author, this.themeId = null, this.isFavorite = false});

  Quote.fromMap(Map<String, dynamic> map) {
    body = map['body'];
    id = map['id'];
    author = Author(
        firstName: map['author']['first_name'],
        lastName: map['author']['last_name'],
        shortDescription: map['author']['short_description'],
        pictureUrl: null);
    isFavorite = false;
  }

  String toText(){
    return "$body - ${author.firstName} ${author.lastName}";
  }
}
