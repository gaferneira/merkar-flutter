import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';

class CreateNewProduct extends StatefulWidget {
  static const routeName = "/create_new_product";

  @override
  _CreateNewProductState createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  final keyNewProduct = GlobalKey<FormState>();
  String nameProduct;
  String nameCategory;
  double quantity;
  double price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.title_new_product),
      ),
      body: _fromCreateProduct(),
    );
  }

  _fromCreateProduct() {
    return Form(
      key: keyNewProduct,
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Nombre"),
              onSaved: (value) {
                nameProduct = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene este campo";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Categoría"),
              onSaved: (value) {
                nameCategory = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Escriba una categoría";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Precio"),
              onSaved: (value) {
                price = value as double;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Ingrese el Precio";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Cantidad"),
              onSaved: (value) {
                quantity = value as double;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Ingrese la cantidad";
                }
                return null;
              },
            ),
            Center(
              child: RaisedButton(
                child: Text(Strings.label_save),
                onPressed: () {
                  _saveNewProduct();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewProduct() {
    if (keyNewProduct.currentState.validate()) {
      keyNewProduct.currentState.save();
    }
  }
}
