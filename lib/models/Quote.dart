
import './Author.dart';

class Quote {
  final String body;
  final Author author;
  final bool isFavorite;  
  
  Quote({this.body, this.author, this.isFavorite = false});
  
}