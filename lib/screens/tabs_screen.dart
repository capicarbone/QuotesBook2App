import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/screens/favorites_list.dart';
import 'package:quotesbook/screens/quotes_list.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/topbar.dart';

import '../providers/quotes.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen();

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  var _selectedPageIndex = 0;
  var _pageController = PageController();
  late final AnimationController _bookmarkIntroController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 510));
  late final _bookmarkIntroAnimation;

  var _bookmarkEnabled = false;

  final bucket = PageStorageBucket();

  final _pages = [];

  void _initPages() {
    if (_pages.isEmpty) {
      _pages.addAll([
        {
          'page': QuotesListScreen(
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
    _initPages();

    _bookmarkIntroAnimation =
        new CurvedAnimation(
            parent: _bookmarkIntroController, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: 500), () {
      _bookmarkIntroController.forward().whenComplete(() {
        Future.delayed(
            Duration(milliseconds: 500),
            () => setState(() {
                  _bookmarkEnabled = true;
                }));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bookmarkIntroController.dispose();
    super.dispose();
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
    Provider.of<Quotes>(context, listen: false).loadSavedQuotes();
    final screenSize = MediaQuery.of(context).size;
    final screenInsets = MediaQuery.of(context).viewPadding;

    final listHeight =
        screenSize.height - Topbar.HEIGHT + (Topbar.SPIKE_HEIGHT / 2);

    final bookmarkHeight = Topbar.HEIGHT + screenInsets.top - 10;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Column(
            children: [
              // I don't use a Positioned widget because throws some
              // "RenderBox was not laid out" error
              SizedBox(
                height: screenSize.height - listHeight + screenInsets.top,
              ),
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
              titles: [
                AppLocalizations.of(context).quotesTab,
                AppLocalizations.of(context).favoritesTab
              ],
              selectedIndex: _selectedPageIndex,
              color: Colors.grey.shade300,
              margin: 25,
            ),
          ),
          Positioned(
            right: 22,
            child: GestureDetector(
              onTap: _onTabSelected,
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _bookmarkEnabled ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: AnimatedContainer(
                      width: 70,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.bounceOut,
                      height: _selectedPageIndex == 1
                          ? bookmarkHeight
                          : bookmarkHeight - 20,
                      child: Bookmark(
                          color: _selectedPageIndex == 1
                              ? Theme.of(context).accentColor
                              : Colors.black12,
                          apexHeight:
                              ((bookmarkHeight - screenInsets.top) * 0.19)
                                  .toInt()),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _bookmarkEnabled ? 0 : 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: AnimatedBuilder(
                        animation: _bookmarkIntroAnimation,
                        builder: (context, child) {
                          return ClipRRect(
                            child: Align(
                              heightFactor: _bookmarkIntroAnimation.value,
                              child: Container(
                                height: bookmarkHeight - 20,
                                width: 70,
                                child: Bookmark(
                                    color: Theme.of(context).accentColor,
                                    apexHeight:
                                        ((bookmarkHeight - screenInsets.top) *
                                                0.19)
                                            .toInt()),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
