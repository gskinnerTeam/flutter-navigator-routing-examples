import 'package:flutter/material.dart';

import 'shared_pages.dart';

//TODO: Add a fade transition
//TODO: Add manual browser sync and deeplink!??

// Declare navModel as a package level variable for demo purposes
// Normally you would pass this around with GetIt or Provider
NavModel _navModel = NavModel();

class DeclarativeNavBasic extends StatelessWidget {
  void _handleCategorySelected(String categoryId) => _navModel.selectedCategory = categoryId;
  void _handleProductSelected(String productId) => _navModel.selectedProduct = productId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (_, __) {
      return AnimatedBuilder(
          animation: _navModel,
          builder: (_, __) {
            return Navigator(
              pages: _buildNavigatorPages(),
              onPopPage: _handlePagePopped,
            );
          });
    });
  }

  // Build a list of Page widgets, that represent our current App state
  // Pages are just a Widget that is tied to a PageRoute
  List<Page> _buildNavigatorPages() {
    return [
      CategoriesPage(_handleCategorySelected),
      if (_navModel.isCategorySelected) ...{
        ProductsPage(
          _handleProductSelected,
          _navModel._selectedCategory,
        ),
      },
      if (_navModel.isProductSelected) ...{
        ProductDetailsPage(
          _navModel._selectedProduct,
        ),
      }
      // Map the list of views, to a list of Pages, as required by Navigator
    ].map((view) => MaterialPage(child: view)).toList();
  }

  bool _handlePagePopped(Route<dynamic> route, dynamic result) {
    if (route.didPop(result)) return true; // Give the route a chance to handle the Pop
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
}

// Declare a simple model to represent our nav
class NavModel extends ChangeNotifier {
  String _selectedProduct;
  String get selectedProduct => _selectedProduct;
  set selectedProduct(String value) => change(() => _selectedProduct = value);
  bool get isProductSelected => _selectedProduct != null;

  String _selectedCategory;
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) => change(() => _selectedCategory = value);
  bool get isCategorySelected => _selectedCategory != null;

  void change(VoidCallback cmd) {
    cmd();
    notifyListeners();
  }
}
