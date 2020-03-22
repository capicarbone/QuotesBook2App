import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quotesbook/l10n/messages_all.dart';

class DemoLocalizations {
  DemoLocalizations(this.localeName);

  static Future<DemoLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return DemoLocalizations(localeName);
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
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
}
