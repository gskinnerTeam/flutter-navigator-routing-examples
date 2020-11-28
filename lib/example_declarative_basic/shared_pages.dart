import 'package:flutter/material.dart';

ButtonStyle _btnStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 100, vertical: 40)),
);

class CategoriesPage extends StatelessWidget {
  const CategoriesPage(this.onCategorySelected, {Key key}) : super(key: key);
  final void Function(String) onCategorySelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("HOME", style: TextStyle(fontSize: 100)),
            ...[
              "Toys",
              "Appliances",
              "Tools",
              "Food",
            ].map((e) {
              return TextButton(
                onPressed: () => onCategorySelected(e),
                child: Text(e),
                style: _btnStyle,
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage(this.onProductSelected, this.selectedCategory, {Key key}) : super(key: key);
  final void Function(String) onProductSelected;

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _BackBtn(),
            Text(selectedCategory, style: TextStyle(fontSize: 100)),
            ...[
              "Product1",
              "Product2",
              "Product3",
              "Product4",
            ].map((e) {
              return TextButton(
                onPressed: () => onProductSelected(e),
                child: Text(e),
                style: _btnStyle,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage(this.selectedProduct, {Key key}) : super(key: key);
  final String selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _BackBtn(),
            Text(selectedProduct, style: TextStyle(fontSize: 100)),
          ],
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(child: Text("<< Back"), onPressed: () => Navigator.of(context).pop());
  }
}
