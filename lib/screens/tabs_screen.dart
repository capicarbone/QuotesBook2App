import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/screens/favorites_list.dart';
import 'package:quotesbook/screens/quotes_list.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/topbar.dart';

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
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SavedQuotes>(context, listen: false).loadSavedQuotes();
    final screenSize = MediaQuery.of(context).size;
    final screenInsets = MediaQuery.of(context).viewPadding;
    final listHeight = screenSize.height - Topbar.HEIGHT + (Topbar.SPIKE_HEIGHT / 2);

    final bookmarkHeight = Topbar.HEIGHT + screenInsets.top - 10;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Column(
            children: [
              // I don't use a Positioned widget because throws some
              // "RenderBox was not laid out" error
              SizedBox(height: screenSize.height - listHeight + screenInsets.top,),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages.map<Widget>((i) => i['page']).toList(),
                  controller: _pageController,
                ),
              ),
            ],
          ),

          SafeArea(
            child: Topbar(
              titles: [AppLocalizations.of(context).quotesTab, AppLocalizations.of(context).favoritesTab],
              selectedIndex: _selectedPageIndex,
              color: Colors.grey.shade300,
              margin: 25,
            ),
          ),
          Positioned(
            right: 22,
            width: 70,
            child: GestureDetector(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                  height: _selectedPageIndex == 1 ? bookmarkHeight : bookmarkHeight - 20,
                  child: Bookmark(color: _selectedPageIndex == 1
                      ? Theme.of(context).accentColor
                      : Colors.black12,
                  apexHeight: ((bookmarkHeight - screenInsets.top)*0.19).toInt()),
                ),
                onTap: _onTabSelected),
          ),
        ],
      ),
    );
  }
}
