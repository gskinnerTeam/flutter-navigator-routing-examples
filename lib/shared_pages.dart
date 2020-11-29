import 'package:flutter/material.dart';

ButtonStyle get _btnStyle => ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
      minimumSize: MaterialStateProperty.all(Size(200, 40)),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
    );

class CategoryListPage extends StatelessWidget {
  const CategoryListPage(this.onCategorySelected, {Key key, this.onLogoutPressed}) : super(key: key);
  final VoidCallback onLogoutPressed;
  final void Function(String) onCategorySelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            if (onLogoutPressed != null)
              TextButton(onPressed: onLogoutPressed, child: Text("LOGOUT"), style: _btnStyle),
            SizedBox(height: 40),
            Text("Choose a category...", style: TextStyle(fontSize: 25)),
            Flexible(
                child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ...[
                    "Toys",
                    "Appliances",
                    "Tools",
                    "Food",
                  ].map((e) {
                    return _CardButton(
                      label: e,
                      onPressed: () => onCategorySelected(e),
                    );
                  }).toList()
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class ProductsListPage extends StatelessWidget {
  const ProductsListPage(this.selectedCategory, this.onProductSelected, {Key key}) : super(key: key);
  final void Function(String) onProductSelected;

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(height: 40),
          _BackBtn(),
          Text(selectedCategory, style: TextStyle(fontSize: 30)),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  "Product1",
                  "Product2",
                  "Product3",
                  "Product4",
                  "Product5",
                  "Product6",
                  "Product7",
                  "Product8",
                ].map((e) {
                  return _CardButton(
                    onPressed: () => onProductSelected(e),
                    label: e,
                  );
                }).toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage(this.selectedProduct, {Key key}) : super(key: key);
  final String selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            _BackBtn(),
            Text(selectedProduct, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage(this.onSigninPressed, {Key key}) : super(key: key);
  final VoidCallback onSigninPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_CardButton(onPressed: onSigninPressed, label: "Sign In")],
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("<< Back"));
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({Key key, this.onPressed, this.label}) : super(key: key);
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      width: 150,
      height: 150,
      child: TextButton(onPressed: onPressed, child: Text(label), style: _btnStyle),
    ));
  }
}
