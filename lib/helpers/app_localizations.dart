import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quotesbook/l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get saveAction {
    return Intl.message(
      'Save',
      name: 'saveAction',
      desc: '',
      locale: localeName
    );
  }

  String get removeAction {
    return Intl.message(
      'Remove',
      name: 'removeAction',
      desc: '',
      locale: localeName
    );
  }

  String get shareAction {
    return Intl.message(
      'Share',
      name: 'shareAction',
      desc: '',
      locale: localeName
    );
  }

  String get someQuotesTitle {
    return Intl.message(
      'Some Quotes',
      name: 'someQuotesTitle',
      desc: 'Title for some quotes screen.',
      locale: localeName,
    );
  }

  String get savedQuotesTitle {
    return Intl.message(
      'Your Favorites',
      name: 'savedQuotesTitle',
      desc: 'Title for favorite quotes screen.',
      locale: localeName,
    );
  }

  String get quotesTab {        
    return Intl.message(
      'Quotes',
      name: 'quotesTab',
      desc: 'Quotes tab label',
      locale: localeName,
    );
    
  }

  String get favoritesTab {
    return Intl.message(
      'Favorites',
      name: 'favoritesTab',
      desc: 'Favorites tab label',
      locale: localeName,
    );
  }

  String get favoritesEmptyMessage {
    return Intl.message(
      'Mark some quotes as favorites.',
      name: 'favoritesEmptyMessage',
      desc: 'Mesasge for empty favorites list',
      locale: localeName
    );
  }

  String get quotesLoadErrorMessage {
    return Intl.message(
      'Some error has ocurred. Trying again.',
      name: 'quotesLoadErrorMessage',
      desc: 'Mesasge for errors on quotes loading',
      locale: localeName
    );
  }

  String get shareQuoteTextOption {
    return Intl.message('Text',
    name: "shareQuoteTextOption",
    desc: 'Share option for text',
      locale: localeName
    );
  }

  String get shareQuoteImageOption {
    return Intl.message('Image',
        name: "shareQuoteImageOption",
        desc: 'Share option for image.',
        locale: localeName
    );
  }

  String get cancelAction {
    return Intl.message('Cancel',
    name: 'cancelAction',
    desc: "",
    locale: localeName);
  }

  String get shareQuoteAs {
    return Intl.message('Share quote as',
    name: 'shareQuoteAs',
    desc: 'share quote description',
    locale: localeName);
  }
}
