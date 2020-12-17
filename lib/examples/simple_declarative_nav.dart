import 'package:flutter/material.dart';
import '../shared_pages.dart';

// A very simple example of using the new Navigator.pages API with a declarative "state first" approach
// Declares a simple NavModel and generates a PageStack based on the current state.
// Is also implements a popPage() method, as that is required when using Navigator.pages.

// TODO: Add RootBackButtonDispatcher to catch Android back events

// Declare navModel as a package level variable for demo purposes (normally you would pass this around with GetIt, Provider etc
NavModel _navModel = NavModel();

class SimpleDeclarativeNav extends StatelessWidget {
  // Some btn handlers, that update the navModel > triggering the AnimatedBuilder > which rebuilds Navigator.pages
  void _handleCategorySelected(String categoryId) => _navModel.selectedCategory = categoryId;
  void _handleProductSelected(String productId) => _navModel.selectedProduct = productId;

  /// Called when [pop] is invoked and the current [Route] corresponds to a [Page] found in the [views] list.
  bool _handlePop(Route route, dynamic result) {
    // If didPop() returns true, we should handle the pop
    if (route.didPop(result)) {
      // Pop the page by asking our navModel to go back
      return _navModel.tryGoBack();
    }
    // Return false meaning we didn't handle this event.
    return false;
  }

  // Compose list of Page widgets, that represent our current App state
  List<MaterialPage> _buildPagesList() {
    return [
      CategoryListPage(_handleCategorySelected),
      if (_navModel.selectedCategory != null) ...{
        ProductsListPage(_navModel.selectedCategory, _handleProductSelected),
      },
      if (_navModel.selectedProduct != null) ...{
        DetailsPage(_navModel.selectedProduct),
      }
      // Map the list of views, to a list of Pages, as required by Navigator
    ].map((view) => MaterialPage(child: view)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, __) {
        return Scaffold(
          // Use an AnimatedBuilder to rebuild when the NavModel changes
          body: AnimatedBuilder(
            animation: _navModel,
            builder: (_, __) {
              return Navigator(
                pages: _buildPagesList(),
                onPopPage: _handlePop,
              );
            },
          ),
        );
      },
    );
  }
}

// Declare a simple model to represent our nav
class NavModel extends ChangeNotifier {
  String _selectedProduct;
  String _selectedCategory;

  String get selectedProduct => _selectedProduct;
  set selectedProduct(String value) => change(() => _selectedProduct = value);

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) => change(() => _selectedCategory = value);

  bool tryGoBack() {
    // If we have a selected product, move back to category.
    if (_navModel.selectedProduct != null) {
      _navModel.selectedProduct = null;
      return true;
    }
    // If we have a selected category, move back to home
    else if (_navModel.selectedCategory != null) {
      _navModel.selectedCategory = null;
      return true;
    }
    // Can't move back anymore, allow the app to be popped
    return false;
  }

  void change(VoidCallback cmd) {
    cmd();
    notifyListeners();
  }
}
