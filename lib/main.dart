import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/providers/quotes.dart';
import 'package:quotesbook/providers/saved_quotes.dart';

import './screens/tabs_screen.dart';
import './widgets/localize_lang_widget.dart';
import './helpers/demo_localizations.dart';

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) => DemoLocalizations.load(locale);

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
          } ,
          update: (_, saved, quotes) {
            if (quotes != null) quotes.savedQuotes = saved.savedQuotes;

            return quotes; 
          } ,
        ),        
      ],
      child: MaterialApp(
        localizationsDelegates: [
          const DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,          
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('es', '')
        ],
        title: 'Quotesbook',
        theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.amber),
        home: LocalizeLang(builder: (lang) => TabsScreen(lang: lang,)  ) ,
      ),
    );
  }
}
