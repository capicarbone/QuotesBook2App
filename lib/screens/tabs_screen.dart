import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/screens/favorites_list.dart';
import 'package:quotesbook/screens/quotes_list.dart';
import 'package:quotesbook/widgets/bookmark.dart';

class AppBarBottomDecorationPainter extends CustomPainter {
  Color color;

  AppBarBottomDecorationPainter({this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    var path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);

    path.close();

    //var paint2 = Paint();
    //paint2.color = Colors.black.withOpacity(0.1);

   // canvas.drawLine(Offset(0, (size.height / 2) + 1),
        //Offset(size.width, (size.height / 2) + 1), paint2);
    canvas.drawShadow(path, Colors.black, 2, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomTopbar extends StatelessWidget {
  String title;
  Color color;
  double margin;

  static const double HEIGHT = 70;
  static const double SPIKE_HEIGHT = 7;

  CustomTopbar({this.title, this.color, this.margin = 25});

  @override
  Widget build(BuildContext context) {
    var diamondMargin = 5.0;
    return Container(
      width: double.infinity,
      height: HEIGHT,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: [
            Positioned(
              bottom: 0,
              height: SPIKE_HEIGHT,
              left: diamondMargin,
              width: constraints.maxWidth - (diamondMargin * 2),
              child: CustomPaint(
                painter: AppBarBottomDecorationPainter(color: color),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: color,
                  height: HEIGHT - (SPIKE_HEIGHT / 2),
                ),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height - CustomTopbar.HEIGHT + (CustomTopbar.SPIKE_HEIGHT / 2);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // I don't use a Positioned widget because throws some
                // "RenderBox was not laid out" error
                SizedBox(height: screenSize.height - listHeight,),
                Expanded(
                  child: PageView(

                    physics: NeverScrollableScrollPhysics(),
                    children: _pages.map<Widget>((i) => i['page']).toList(),
                    controller: _pageController,
                  ),
                ),
              ],
            ),

            CustomTopbar(
              title: "home",
              color: Colors.grey.shade300,
              margin: 25,
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
                        height: _selectedPageIndex == 1 ? CustomTopbar.HEIGHT - 10 : CustomTopbar.HEIGHT - 30,
                        child: Bookmark(_selectedPageIndex == 1
                            ? Theme.of(context).accentColor
                            : Colors.black12),
                      ),
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
