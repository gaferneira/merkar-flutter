import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'select_my_favorites_view_model.dart';

class SelectMyFavoritesPage extends StatefulWidget {
  static const routeName = "/select_my_favorites_page";

  @override
  _SelectMyFavoritesPageState createState() => _SelectMyFavoritesPageState();
}

class _SelectMyFavoritesPageState extends State<SelectMyFavoritesPage> {
  SelectMyFavoritesViewModel viewModel =
      serviceLocator<SelectMyFavoritesViewModel>();
  //List<ListProduct> shoppingProducts;
  ShoppingList shoppingList;
  @override
  Widget build(BuildContext context) {
    shoppingList = ModalRoute.of(context).settings.arguments;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<SelectMyFavoritesViewModel>.value(
        value: viewModel,
        child: Consumer<SelectMyFavoritesViewModel>(
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
