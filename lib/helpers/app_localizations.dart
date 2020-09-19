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
}