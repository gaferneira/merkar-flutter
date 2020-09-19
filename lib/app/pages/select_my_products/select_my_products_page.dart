import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/new_product/create_new_product.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'select_my_products_view_model.dart';

class SelectMyProductsPage extends StatefulWidget {
  static const routeName = "/select_my_products_page";

  @override
  _SelectMyProductsPageState createState() => _SelectMyProductsPageState();
}

class _SelectMyProductsPageState extends State<SelectMyProductsPage> {
  SelectMyProductsViewModel viewModel =
      serviceLocator<SelectMyProductsViewModel>();
  //List<ListProduct> shoppingProducts;
  ShoppingList shoppingList;
  @override
  Widget build(BuildContext context) {
    shoppingList = ModalRoute.of(context).settings.arguments;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<SelectMyProductsViewModel>.value(
        value: viewModel,
        child: Consumer<SelectMyProductsViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.title_my_products),
                  ),
                  body: SingleChildScrollView(
                    child: (viewModel.userProducts == null)
                        ? Text('Loading...')
                        : _showProductsList(viewModel.userProducts),
                  ),
                  floatingActionButton: FloatingActionButton(
                    tooltip: Strings.label_tootip_new_product,
                    child: Icon(Icons.add),
                    onPressed: () {
                      _createNewProduct(context);
                    },
                  ),
                )));
  }

  Widget _showProductsList(List<Product> userProducts) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: userProducts.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text("${userProducts[index].name}"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool value) {
              viewModel.selectProduct(index, value);
            },
            value: userProducts[index].selected,
            activeColor: Colors.cyan,
            checkColor: Colors.green,
          );
        });
  }

  _createNewProduct(BuildContext context) {
    Navigator.of(context).pushNamed(CreateNewProduct.routeName);
  }
}
