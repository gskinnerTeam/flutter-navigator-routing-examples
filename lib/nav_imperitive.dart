import 'package:flutter/material.dart';
import 'package:navigator2_tests/views.dart';
import 'main.dart';

class NavigatorTest_Pages1 extends StatefulWidget {
  @override
  _NavigatorTest_Pages1State createState() => _NavigatorTest_Pages1State();
}

class _NavigatorTest_Pages1State extends State<NavigatorTest_Pages1> {
  // Create a simple list of Page widgets we can control directly
  List<Page> _pages = [];

  @override
  initState() {
    // Add the first page to our stack, this will act as the 'initial route'
    _addPage(GenresListView(onGenrePressed: _handleGenrePressed));
    super.initState();
  }

  // Since we can access the pages list directly, it's easy to grab the name from the current Page if we want
  String get currentTitle => _pages.last.name;

  //Adds a new page to the pageList, and rebuilds the widget
  void _addPage(Widget view, {String name = ""}) {
    // Navigator requires all views are wrapped in a Page(), we'll use MaterialPage for convenience
    setState(() {
      _pages.add(MaterialPage(child: view, name: name, key: ValueKey(name)));
      _pages = List.from(_pages);
    });
  }

  void _handleGenrePressed(String genreId) {
    _addPage(BookListView(genreId: genreId, onBookPressed: _handleBookPressed), name: "Books");
  }

  void _handleBookPressed(String bookId) {
    _addPage(BookDetailsView(bookId: bookId), name: "Book Info");
  }

  // Adjust our stack of Widgets a pop is received
  bool _handlePagePop(Route<dynamic> route, dynamic result) {
    // See if the route can handle the pop itself
    bool didPop = route.didPop(result);
    // If child didn't pop, try and pop our own pages stack
    if (!didPop) {
      return popPage();
    }
    return didPop;
  }

  bool popPage() {
    bool pop = _pages.length > 1;
    if (pop) setState(() => _pages = List.from(_pages)..removeLast());
    return pop;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TitleBar(title: currentTitle, onBackPressed: popPage),
            // Navigator
            Flexible(
              child: Navigator(
                // We tell navigator which pages it should have, not the other way around!
                pages: _pages,
                // Because we are in full control, we need to manually handle back as well
                onPopPage: _handlePagePop,
              ),
            ),
            BottomMenuBar(),
          ],
        ),
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key key, this.title, this.onBackPressed}) : super(key: key);
  final String title;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Back Button
        if (onBackPressed != null)
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            // We can use pop() calls as expected, it will be handled by `Navigator.onPopPage`
            onPressed: onBackPressed,
          ),
        // Centered Title Text
        Align(alignment: Alignment.center, child: Text(title)),
      ],
    );
  }
}

class BottomMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
