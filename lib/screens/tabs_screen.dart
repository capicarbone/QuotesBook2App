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
  var _pageController = PageController();

  final bucket = PageStorageBucket();

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


  @override
  void initState() {
    super.initState();
    _initPages();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onTabSelected(pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });

    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut
    );

  }

  @override
  Widget build(BuildContext context) {
    final selectedPage = _pages[_selectedPageIndex];
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              children: _pages.map<Widget>((i) => i['page']).toList(),
              controller: _pageController,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onTabSelected,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text(AppLocalizations.of(context).quotesTab),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              title: Text(AppLocalizations.of(context).favoritesTab),
            )
          ]),
    );
  }
}
