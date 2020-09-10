import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/products/list_suggerid_products.dart';
import 'package:provider/provider.dart';

import '../../../app/pages/shopping_list/shopping_list_view_model.dart';
import '../../../data/entities/list_product.dart';
import '../../../data/entities/shopping_list.dart';
import '../../../injection_container.dart';

class ShoppingListPage extends StatefulWidget {
  static const routeName = '/showselectlist';
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  ShoppingListViewModel viewModel = serviceLocator<ShoppingListViewModel>();

  @override
  Widget build(BuildContext context) {
    final shoppingList =
        ModalRoute.of(context).settings.arguments as ShoppingList;
    viewModel.loadData(shoppingList);
    return ChangeNotifierProvider<ShoppingListViewModel>(
        create: (context) => viewModel,
        child: Consumer<ShoppingListViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text('${shoppingList.name}'),
                  ),
                  body: SingleChildScrollView(
                    child: (viewModel.list == null)
                        ? Text('Loading...')
                        : _showProductsList(viewModel.list),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => {_showListSuggerProducts(context)},
                    tooltip: Constant.label_tootip_add_products,
                    child: Icon(Icons.add),
                  ),
                )));
  }

  _showListSuggerProducts(BuildContext context) async {
    Navigator.of(context).pushNamed(ListSuggeridProducts.routeName);
  }

  Widget _showProductsList(List<ListProduct> listProducts) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: listProducts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${listProducts[index].name}"),
          onTap: () {},
        );
      },
    );
  }
}
