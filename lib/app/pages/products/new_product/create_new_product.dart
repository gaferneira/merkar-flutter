import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';

import 'create_new_product_view_model.dart';

class CreateNewProduct extends StatefulWidget {
  static const routeName = "/create_new_product";

  @override
  _CreateNewProductState createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  final keyNewProduct = GlobalKey<FormState>();

  CreateNewProductsViewModel viewModel =
      serviceLocator<CreateNewProductsViewModel>();

  String nameProduct;
  String nameCategory;
  String price;

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.title_new_product),
        ),
        body: _fromCreateProduct(),
      ),
    );
  }

  Widget _fromCreateProduct() {
    return Form(
      key: keyNewProduct,
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: true,
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
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                price = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Ingrese el Precio";
                }
                return null;
              },
              textInputAction: TextInputAction.done,
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
      Product product = new Product(
          category: nameCategory, name: nameProduct, price: price.toString());
      //Implement save
      viewModel.saveProduct(product, context);
      Navigator.pop(context);
    }
  }
}
