import 'package:flutter/material.dart';
import 'package:navigator2_tests/views.dart';

import 'nav_imperitive.dart';

void main() {
  //runApp(NavigatorTest_Pages1());
  runApp(DeclerativeNavTest1());
}

class NavModel extends ChangeNotifier {
  String _selectedProduct;
  String get selectedProduct => _selectedProduct;
  set selectedProduct(String value) {
    _selectedProduct = value;
    notifyListeners();
  }

  String _selectedCategory;
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void change(VoidCallback cmd) {
    cmd();
    notifyListeners();
  }
}

NavModel _navModel = NavModel();
NavModel get navModel => _navModel; //Protect model from re-assignment

class DeclerativeNavTest1 extends StatelessWidget {
  void _handleCategoryPressed() => navModel.selectedCategory = "toys";
  void _handleProductPressed() => navModel.selectedProduct = "xbox";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (_, __) {
      return Scaffold(
        body: AnimatedBuilder(
            animation: _navModel,
            builder: (_, __) {
              return Navigator(
                  // Declaretively decide what is the current stack of pages
                  pages: [
                    CategoriesPage(onPressed: _handleCategoryPressed),
                    if (_navModel.selectedCategory != null) ...{
                      ProductsPage(onPressed: _handleProductPressed),
                    },
                    if (_navModel.selectedProduct != null) ...{
                      ProductDetailsPage(),
                    }
                    // Map the list of views, to a list of Pages, as required by Navigator
                  ].map((view) => MaterialPage(child: view)).toList(),
                  // Handle Pop for any of our pages
                  onPopPage: (Route<dynamic> route, dynamic result) {
                    if (route.didPop(result)) return true; // Give the route a chance to handle the Pop
                    // If we have a selected product, move back to category.
                    if (navModel.selectedProduct != null) {
                      navModel.selectedProduct = null;
                      return true;
                    }
                    // If we have a selected category, move back to home
                    else if (navModel.selectedCategory != null) {
                      navModel.selectedCategory = null;
                      return true;
                    }
                    // Can't move back anymore, allow the app to be popped
                    return false;
                  });
            }),
      );
    });
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("HOME", style: TextStyle(fontSize: 32)),
          RaisedButton(onPressed: onPressed, child: Text("PICK CATEGORY")),
        ],
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("PRODUCTS", style: TextStyle(fontSize: 32)),
          RaisedButton(onPressed: onPressed, child: Text("PICK PRODUCT")),
        ],
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.red.shade700,
        child: Text("DETAILS"),
      ),
    );
  }
}
