import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/new_product/create_new_product_view_model.dart';
import 'package:merkar/app/pages/select_my_products/select_my_products_page.dart';
import 'package:merkar/app/pages/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/product.dart';

import '../../../injection_container.dart';

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
      Navigator.of(context).pushNamed(SelectMyProductsPage.routeName);
    }
  }
}
