import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/screens/favorites_list.dart';
import 'package:quotesbook/screens/quotes_list.dart';
import 'package:quotesbook/widgets/bookmark.dart';

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

  _onTabSelected() {
    setState(() {
      _selectedPageIndex = (_selectedPageIndex == 1) ? 0 : 1;
    });

    _pageController.animateToPage(_selectedPageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SavedQuotes>(context, listen: false).loadSavedQuotes();
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
            ),
            Positioned(
              right: 22,
              child: GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 70,
                        curve: Curves.bounceOut,
                        height: _selectedPageIndex == 1 ? 70 : 42,
                        child: Bookmark(_selectedPageIndex == 1
                            ? Colors.amber
                            : Colors.black12),
                      ),
                      /*
                                if (quote.isFavorite)
                                  Container(
                                    child: Center(
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                    ),
                                    width: 50,
                                    height: 40,
                                  ) */
                    ],
                  ),
                  onTap: _onTabSelected),
            ),
          ],
        ),
      ),
    );
  }
}
