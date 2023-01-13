import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/quotes_provider.dart';
import 'package:quotesbook/providers/quotes.dart';
import 'package:sqflite/sqflite.dart';

import './screens/tabs_screen.dart';
import './widgets/localize_lang_widget.dart';
import './helpers/app_localizations.dart';
import 'helpers/db_helper.dart';

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

Future main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    var blackTintColor = Color(0xFF3B3840);
    var accentColor = Color(0xFFFFA95A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', ''), const Locale('es', '')],
      title: 'Quotesbook',
      theme: ThemeData(
        primaryColor: blackTintColor,
        accentColor: accentColor,
        primaryTextTheme: TextTheme(
            bodyText1: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: blackTintColor))),
      ),
      home: FutureBuilder<Database>(
          future: DBHelper.getDatabase(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var db = snapshot.data;
            var quotesProvider = QuotesProvider(db: db);
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => Quotes(quotesProvider)),
                ],
                child: LocalizeLang(
                    builder: (lang) => TabsScreen(
                          lang: lang,
                        )),
              );
            }

            return Container(
              color: Colors.grey.shade300,
            );
          }),
    );
  }
}
