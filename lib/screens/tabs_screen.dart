import 'package:flutter/material.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/screens/favorites_list.dart';
import 'package:quotesbook/screens/quotes_list.dart';

class TabsScreen extends StatefulWidget {
  var lang = 'en';

  TabsScreen({this.lang});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  var _selectedPageIndex = 0;

  final _pages = [];

  void _initPages() {
    if (_pages.isEmpty) {
      _pages.addAll([
        {          
          'page': QuotesListScreen(
            lang: widget.lang,
            key: PageStorageKey('Quotes'),
          ),
        },
        {          
          'page': FavoritesScreen(
            key: PageStorageKey('Favorites'),
          )
        }
      ]);
    }
  }

  AnimationController _controller;
  final bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initPages();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _selectPage(pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPage = _pages[_selectedPageIndex];
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 0 ? localizations.someQuotesTitle : localizations.savedQuotesTitle),
      ),
      body: IndexedStack(
        index: _selectedPageIndex,
        children: _pages.map<Widget>((i) => i['page']).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text(AppLocalizations.of(context).quotesTab),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text(AppLocalizations.of(context).favoritesTab),
            )
          ]),
    );
  }
}
