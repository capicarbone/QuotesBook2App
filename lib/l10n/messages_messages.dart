// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'messages';

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'cancelAction': MessageLookupByLibrary.simpleMessage('Cancel'),
    'favoritesEmptyMessage': MessageLookupByLibrary.simpleMessage('Mark some quotes as favorites.'),
    'favoritesTab': MessageLookupByLibrary.simpleMessage('Favorites'),
    'quotesLoadErrorMessage': MessageLookupByLibrary.simpleMessage('Some error has ocurred. Trying again.'),
    'quotesTab': MessageLookupByLibrary.simpleMessage('Quotes'),
    'removeAction': MessageLookupByLibrary.simpleMessage('Remove'),
    'saveAction': MessageLookupByLibrary.simpleMessage('Save'),
    'savedQuotesTitle': MessageLookupByLibrary.simpleMessage('Your Favorites'),
    'shareAction': MessageLookupByLibrary.simpleMessage('Share'),
    'shareQuoteAs': MessageLookupByLibrary.simpleMessage('Share quote as'),
    'shareQuoteImageOption': MessageLookupByLibrary.simpleMessage('Image'),
    'shareQuoteTextOption': MessageLookupByLibrary.simpleMessage('Text'),
    'someQuotesTitle': MessageLookupByLibrary.simpleMessage('Some Quotes')
  };
}
