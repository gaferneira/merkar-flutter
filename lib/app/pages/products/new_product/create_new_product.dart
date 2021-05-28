import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/resources/constants.dart';
import '../../../core/resources/strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../../data/entities/product.dart';
import '../../../../injection_container.dart';
import 'create_new_product_view_model.dart';

class CreateNewProduct extends StatefulWidget {
  static const routeName = "/create_new_product";

  @override
  _CreateNewProductState createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  final keyNewProduct = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
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
              decoration: InputDecoration(labelText: Strings.label_name),
              onSaved: (value) {
                nameProduct = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return Strings.error_required_field;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.category ?? "",
              decoration: InputDecoration(labelText: Strings.category),
              onSaved: (value) {
                nameCategory = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.price ?? "",
              decoration: InputDecoration(labelText: Strings.price),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                price = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.unit ?? "",
              decoration: InputDecoration(labelText: Strings.unit),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                unit = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: Constant.normalspace),
            Center(
              child: _buildSaveButton(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSaveButton(){
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
    }
    return  PrimaryButton(
        title: Strings.label_save,
        onPressed: () {
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
        );
  }
}
