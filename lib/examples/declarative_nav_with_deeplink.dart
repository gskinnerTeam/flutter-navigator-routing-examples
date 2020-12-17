import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared_pages.dart';

/// This builds on [SimpleDeclarativeNav] example, and adds manual deep-linking and web-location updates.
/// Showing how you can still deeplink without using Router directly. 

// Declare navModel as a package level variable for demo purposes (normally you would pass this around with GetIt, Provider etc
NavModel _navModel = NavModel();

// Utility method to report our current path back to the OS/Browser
String _prevPath;
void syncSystemPath(String value) {
  if (value != _prevPath) {
    SystemNavigator.routeUpdated(routeName: value ?? "/", previousRouteName: _prevPath ?? "/");
    _prevPath = value;
  }
}

// Utility method to get the initial path from the Sytem/Browser, we can use this to deeplink
String get initialSystemPath => WidgetsBinding.instance.window.defaultRouteName;

class DeclarativeNavWithDeeplink extends StatefulWidget {
  @override
  _DeclarativeNavWithDeeplinkState createState() => _DeclarativeNavWithDeeplinkState();
}

class _DeclarativeNavWithDeeplinkState extends State<DeclarativeNavWithDeeplink> {
  // Some btn handlers, that update the navModel > triggering the AnimatedBuilder > which rebuilds Navigator.pages
  void _handleCategorySelected(String categoryId) => _navModel.selectedCategory = categoryId;
  void _handleProductSelected(String productId) => _navModel.selectedProduct = productId;

  @override
  void initState() {
    super.initState();
    // Get the initial deeplink value and inject it into our NavModel
    _navModel.parseDeeplink(initialSystemPath);
    // Hook system BACK event into our app state, this is primarily for Android
    BackButtonInterceptor.add((_, __) => _navModel.tryGoBack());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (_, __) {
      return Scaffold(
        // Use an AnimatedBuiler to rebuild when the NavModel changes
        body: AnimatedBuilder(
          animation: _navModel,
          builder: (_, __) {
            //Whenever we rebuild, sync the browser path
            syncSystemPath(_navModel.currentPath);
            return Navigator(
              pages: _buildPages(),
              onPopPage: _handlePop,
            );
          },
        ),
      );
    });
  }

  /// Called when [pop] is invoked and the current [Route] corresponds to a [Page] found in the [views] list.
  bool _handlePop(Route route, dynamic result) {
    bool result = false;
    // If didPop() returns true, we should handle the pop
    if (route.didPop(result)) {
      // Pop the page by asking our navModel to go back
      result = _navModel.tryGoBack();
    }
    // Return false meaning we didn't handle this event.
    return result;
  }

// Compose list of Page widgets, that represent our current App state
  List<MaterialPage> _buildPages() {
    return [
      CategoryListPage(_handleCategorySelected),
      if (_navModel.isCategorySelected) ...{
        ProductsListPage(
          _navModel._selectedCategory,
          _handleProductSelected,
        ),
      },
      if (_navModel.isProductSelected) ...{
        DetailsPage(_navModel._selectedProduct),
      }
      // Map the list of views, to a list of Pages, as required by Navigator
    ].map((view) => MaterialPage(child: view)).toList();
  }
}

// Declare a simple model to represent our nav
class NavModel extends ChangeNotifier {
  String _selectedProduct;
  String _selectedCategory;

  bool get isProductSelected => _selectedProduct != null;
  String get selectedProduct => _selectedProduct;
  set selectedProduct(String value) => change(() => _selectedProduct = value);

  bool get isCategorySelected => _selectedCategory != null;
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) => change(() => _selectedCategory = value);

  String get currentPath {
    String path = "/";
    if (isCategorySelected) {
      path += "$selectedCategory/";
      if (isProductSelected) {
        path += "$selectedProduct/";
      }
    }
    return path;
  }

  void parseDeeplink(String deeplinkPath) {
    List<String> segments = deeplinkPath.split("/")..removeWhere((e) => e == "");
    _selectedCategory = _selectedProduct = null;
    if (segments.length > 0) {
      selectedCategory = segments[0];
      if (segments.length > 1) {
        selectedProduct = segments[1];
      }
    }
  }

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
