import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared_pages.dart';

//TODO: Add a fade transition
//TODO: Add manual browser sync and deeplink!??

// SystemNavigator.routeUpdated(routeName: routeName, previousRouteName: _lastAnnouncedRouteName

// Declare navModel as a package level variable for demo purposes (normally you would pass this around with GetIt, Provider etc
NavModel _navModel = NavModel();

String _prevPath;
void syncSystemPath(String value) {
  if (value != _prevPath) {
    _prevPath = value;
    SystemNavigator.routeUpdated(routeName: value ?? "/", previousRouteName: _prevPath ?? "/");
  }
}

String get initialSystemPath => WidgetsBinding.instance.window.defaultRouteName;

class DeclarativeNavBasic extends StatefulWidget {
  // Some btn handlers, that update the navModel > triggering the AnimatedBuilder > which rebuilds Navigator.pages
  @override
  _DeclarativeNavBasicState createState() => _DeclarativeNavBasicState();
}

class _DeclarativeNavBasicState extends State<DeclarativeNavBasic> {
  void _handleCategorySelected(String categoryId) => _navModel.selectedCategory = categoryId;
  void _handleProductSelected(String productId) => _navModel.selectedProduct = productId;
  void _handleSignInPressed() => _navModel.isSignedIn = true;
  void _handleSignOutPressed() => _navModel.clear();

  @override
  void initState() {
    super.initState();
    // Get the initial deeplink from web / device(???)
    _navModel.parseDeeplink(initialSystemPath);
    // Hook system BACK event into our app state, this is primarily for Android
    BackButtonInterceptor.add((_, __) => _navModel.tryGoBack());
    // Listen for nav changes, and browser know we've changed
    //_navModel.addListener(() => syncBrowserLocation(_navModel.currentPath));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (_, __) {
      return Scaffold(
        body: AnimatedBuilder(
          animation: _navModel,
          builder: (_, __) {
            //Whenever we rebuild, sync the system path
            syncSystemPath(_navModel.currentPath);

            return Navigator(
              // Compose list of Page widgets, that represent our current App state
              pages: [
                // Show an authPage if needed
                if (!_navModel.isSignedIn) ...{
                  AuthPage(_handleSignInPressed),
                }
                // If we're signed in, show other pages according to state
                else ...{
                  CategoryListPage(_handleCategorySelected, _handleSignOutPressed),
                  if (_navModel.isCategorySelected) ...{
                    ProductsListPage(_navModel._selectedCategory, _handleProductSelected),
                  },
                  if (_navModel.isProductSelected) ...{
                    DetailsPage(_navModel._selectedProduct),
                  }
                },
                // Map the list of views, to a list of Pages, as required by Navigator
              ].map((view) => MaterialPage(child: view)).toList(),

              /// Called when [pop] is invoked and the current [Route] corresponds to a [Page] found in the [pages] list.
              onPopPage: (Route route, dynamic result) {
                // Allow top page-route to handle pop()
                if (route.didPop(result)) {
                  syncSystemPath(_navModel.currentPath);
                }
                return _navModel.tryGoBack();
                // Otherwise, handle it in our own nav model and return the results
              },
            );
          },
        ),
      );
    });
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

  bool _isSignedIn = true;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(bool value) => change(() => _isSignedIn = value);

  void clear() {
    isSignedIn = false;
    selectedCategory = null;
    selectedProduct = null;
  }

  bool tryGoBack() {
    // Cant go back if we're not signed in
    if (!isSignedIn) return false;
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
}
