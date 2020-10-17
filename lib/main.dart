import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/providers/quotes.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/screens/quote_details_screen.dart';

import './screens/tabs_screen.dart';
import './widgets/localize_lang_widget.dart';
import './helpers/app_localizations.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedQuotes()),
        ListenableProxyProvider<SavedQuotes, Quotes>(
          create: (_) {
            return Quotes();
          },
          update: (_, saved, quotes) {
            if (quotes != null) quotes.savedQuotes = saved.savedQuotes;

            return quotes;
          },
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics)
        ],
        localizationsDelegates: [
          const DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('en', ''), const Locale('es', '')],
        title: 'Quotesbook',
        theme: ThemeData(
          primaryColor: Color(0xFF00BCD4),
          accentColor: Colors.amber,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          ),
        ),
        home: LocalizeLang(
            builder: (lang) => TabsScreen(
                  lang: lang,
                )),
        routes: {
          QuoteDetailsScreen.routeName: (context) => QuoteDetailsScreen(),
        }
      ),
    );
  }
}
