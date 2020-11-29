import 'package:flutter/material.dart';
import '../shared_pages.dart';

// A very simple example of using the new Navigator.pages API with a imperative approach
// We will essentially re-create the existing Push/Pop APIs, but the nice thing here is
// you know get full control of the nav stack.

// So you can add any methods you like, allowing you to customize the stack on the fly, according
// to your specific business logic.

// NOTE: This currently does not handle Android back button properly. Not sure how to catch it here without using an external package...

// Declare navModel as a package level variable for demo purposes (normally you would pass this around with GetIt, Provider etc
NavController _navController = NavController();

// Declare a simple Model to control our pageStack
class NavController extends ChangeNotifier {
  List<Widget> _views = [];
  List<Widget> get views => _views;
  set views(List<Widget> value) {
    _views = value;
    notifyListeners();
  }

  // Convenience method to wrap our of View Widgets in Page Widgets as required by Navigator
  List<MaterialPage> get routes => _views.map((e) => MaterialPage(child: e)).toList();

  void push(Widget view) => views = List.from(views)..add(view);

  void popUntilFirst() => views = List.from(views)..removeRange(1, views.length);

  bool pop(Route route, dynamic result) {
    if (route.didPop(result)) {
      if (views.length > 1) {
        views = List.from(views)..removeLast();
        return true;
      }
    }
    return false;
  }
}

class SimpleImperativeNav extends StatefulWidget {
  // Add a new page to the stack
  @override
  _SimpleImperativeNavState createState() => _SimpleImperativeNavState();
}

class _SimpleImperativeNavState extends State<SimpleImperativeNav> {
  @override
  void initState() {
    super.initState();
    // Add the initial page to our stack, this will be the initalView in the Navigator
    _navController.push(CategoryListPage(_handleCategorySelected));
  }

  void _handleCategorySelected(String categoryId) {
    //Push Page:
    _navController.push(ProductsListPage(categoryId, _handleProductSelected));
  }

  void _handleProductSelected(String productId) {
    // Push Page:
    _navController.push(DetailsPage(productId));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, __) {
        return Scaffold(
          // Use an AnimatedBuiler to rebuild when the NavModel changes
          body: AnimatedBuilder(
            animation: _navController,
            builder: (_, __) {
              return Navigator(
                pages: _navController.routes,
                onPopPage: _navController.pop,
              );
            },
          ),
        );
      },
    );
  }
}
