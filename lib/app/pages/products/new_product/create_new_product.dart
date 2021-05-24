import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_colors.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
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

  String? nameProduct;
  String? nameCategory;
  String? price;
  String? unit;
  Product? product;

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)!.settings.arguments as Product?;
    return SlideInDown(
      child: Scaffold(
        appBar: AppBar(
          title: (product == null)
              ? Text(Strings.title_new_product)
              : Text(Strings.editProductTittle + " " + product!.name!),
        ),
        body: SingleChildScrollView(child: _fromCreateProduct()),
      ),
    );
  }

  Widget _fromCreateProduct() {
    return Form(
      key: keyNewProduct,
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspacecontainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: product?.name ?? "",
              autofocus: true,
              decoration: InputDecoration(labelText: "Nombre"),
              onSaved: (value) {
                nameProduct = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Llene este campo";
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.category ?? "",
              decoration: InputDecoration(labelText: "Categoría"),
              onSaved: (value) {
                nameCategory = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return "Escriba una categoría";
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.price ?? "",
              decoration: InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                price = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return "Ingrese el Precio";
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.unit ?? "",
              decoration: InputDecoration(labelText: "Unidad"),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                unit = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return "Ingrese la Unidad";
              },
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: Constant.normalspace),
            Center(
              child: RaisedButton(
                child: Text(Strings.label_save),
                color: AppColors.lightColor,
                textColor: AppColors.textColorButtomLight,
                shape: AppStyles.borderRadius,
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
    if (keyNewProduct.currentState!.validate() == true) {
      keyNewProduct.currentState!.save();

      Product newProduct = new Product(
          category: nameCategory,
          name: nameProduct,
          price: price.toString(),
          unit: unit.toString());

      if (product != null) {
        newProduct.id = product!.id;
        newProduct.path = product!.path;
      }

      viewModel.saveProduct(newProduct, context);
    }
  }
}
