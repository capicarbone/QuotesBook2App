import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/providers/quotes.dart';

import './screens/quotes_list.dart';
import './screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Quotes(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('es')
        ],
        title: 'Quotesbook',
        theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.amber),
        home: TabsScreen(),
      ),
    );
  }
}
