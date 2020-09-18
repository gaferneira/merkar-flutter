import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/select_my_products/select_my_products_page.dart';
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
                    child: Column(
                      children: <Widget>[
                        Center(child: Text("No seleccionados")),
                        (viewModel.unselectedList == null)
                            ? Text('Loading...')
                            : _showProductsList(viewModel.unselectedList),
                        Center(child: Text("Seleccionados")),
                        (viewModel.selectedList == null)
                            ? Text('Loading...')
                            : _showSelectProductsList(viewModel.selectedList),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        {_showListSuggerProducts(context, shoppingList)},
                    tooltip: Strings.label_tootip_add_products,
                    child: Icon(Icons.add),
                  ),
                )));
  }

  _showListSuggerProducts(
      BuildContext context, ShoppingList shoppingList) async {
    Navigator.of(context)
        .pushNamed(SelectMyProductsPage.routeName, arguments: shoppingList);
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
        return CheckboxListTile(
          title: Text("${listProducts[index].name}"),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) {
            viewModel.selectProduct(index);
          },
          value: listProducts[index].selected,
          activeColor: Colors.cyan,
          checkColor: Colors.green,
        );
        /*return ListTile(
          title: Text("${listProducts[index].name}"),
          onTap: () {},
        );*/
      },
    );
  }

  Widget _showSelectProductsList(List<ListProduct> listProducts) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: listProducts.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text("${listProducts[index].name}"),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) {
            if (value)
              viewModel.selectProduct(index);
            else
              viewModel.unselectProduct(index);
          },
          value: listProducts[index].selected,
          activeColor: Colors.cyan,
          checkColor: Colors.green,
        );
        /*return ListTile(
          title: Text("${listProducts[index].name}"),
          onTap: () {},
        );*/
      },
    );
  }
}
