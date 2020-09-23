import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
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
  final keyFormEditProduct = GlobalKey<FormState>();
  final keyFormFinishShoppingList = GlobalKey<FormState>();
  ShoppingListViewModel viewModel = serviceLocator<ShoppingListViewModel>();
  int temp_quantity = null;
  double temp_price = null;
  String descriptionShoppingList = "";
  bool _character = false;
  bool _character1 = false;
  bool _character2 = false;
  int _selectedRadio = 0;
  @override
  Widget build(BuildContext context) {
    final shoppingList =
        ModalRoute.of(context).settings.arguments as ShoppingList;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<ShoppingListViewModel>.value(
        value: viewModel,
        child: Consumer<ShoppingListViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text('${shoppingList.name}'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {
                          _finishShoppingList(shoppingList, context);
                        },
                      ),
                    ],
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
                        RaisedButton(
                            child: Text(Strings.label_finish),
                            onPressed: () {
                              _finishShoppingList(shoppingList, context);
                            }),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        {_showListSuggerProducts(context, shoppingList)},
                    tooltip: Strings.label_tootip_add_products,
                    child: Icon(Icons.add),
                  ),
                  bottomNavigationBar: Container(
                      height: Constant.bottomBarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: BottomNavigationBar(
                        currentIndex:
                            0, // this will be set when a new tab is tapped
                        items: [
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.insert_chart),
                            title: new Text('Total: ${viewModel.totalPrice()}'),
                          ),
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.shopping_cart),
                            title: new Text(
                                'Carrito (${viewModel.totalShopping()})'),
                          ),
                        ],
                      )),
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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${listProducts[index].name}",
              ),
              Row(
                children: <Widget>[
                  Text(
                      "${listProducts[index].quantity} = ${listProducts[index].price}"),
                ],
              )
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) {
            viewModel.selectProduct(index);
          },
          secondary: IconButton(
            icon: Icon(Icons.edit),
            tooltip: Strings.label_edit,
            onPressed: () {
              _showEditProduct(listProducts[index], context);
            },
          ),
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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${listProducts[index].name}",
              ),
              Row(
                children: <Widget>[
                  Text(
                      "${listProducts[index].quantity} = ${listProducts[index].price}"),
                ],
              )
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) {
            if (value)
              viewModel.selectProduct(index);
            else
              viewModel.unselectProduct(index);
          },
          secondary: IconButton(
            icon: Icon(Icons.edit),
            tooltip: Strings.label_edit,
            onPressed: () {
              _showEditProduct(listProducts[index], context);
            },
          ),
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

  Future<void> _showEditProduct(
      ListProduct product, BuildContext context) async {
    switch (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.editProductTittle + ": ${product.name}"),
        content: Form(
          key: keyFormEditProduct,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: "${product.quantity}",
                decoration: InputDecoration(labelText: Strings.label_quantity),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Ingrese la cantidad";
                  } else
                    return null;
                },
                onSaved: (value) {
                  this.temp_quantity = int.parse(value);
                },
              ),
              TextFormField(
                initialValue: "${product.price}",
                decoration: InputDecoration(labelText: Strings.label_price),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Ingrese un valor";
                  } else
                    return null;
                },
                onSaved: (value) {
                  this.temp_price = double.parse(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(Constant.normalspace),
                child: Center(
                  child: RaisedButton(
                      child: Text(Strings.label_save),
                      onPressed: () {
                        _saveEditProduct(product);
                        Navigator.pop(context, "${Strings.label_save}");
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    )) {
      default:
        //Whatever
        break;
    }
  }

  Future<void> _finishShoppingList(
      ShoppingList shoppingList, BuildContext context) async {
    switch (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${shoppingList.name}"),
        content: Form(
          key: keyFormFinishShoppingList,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: this.descriptionShoppingList,
                decoration:
                    InputDecoration(labelText: Strings.label_description),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Llene la Descripción";
                  } else
                    return null;
                },
                onSaved: (value) {
                  this.temp_price = double.parse(value);
                },
              ),
              _showCircleRadioButtoms(context),
              Padding(
                padding: const EdgeInsets.all(Constant.normalspace),
                child: Center(
                  child: RaisedButton(
                      child: Text(Strings.label_finish),
                      onPressed: () {
                        //Hacer la acción
                        Navigator.pop(context, "${Strings.label_finish}");
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    )) {
      default:
        //Whatever
        break;
    }
  }

  void _saveEditProduct(ListProduct product) {
    if (keyFormEditProduct.currentState.validate()) {
      keyFormEditProduct.currentState.save();
      String oldTotal = product.total;
      product.quantity = this.temp_quantity;
      product.total = (this.temp_price * this.temp_quantity).toString();
      viewModel.updateProduct(product, oldTotal);
    }
  }

  Widget _showCircleRadioButtoms(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Eliminar la lista'),
          leading: Radio(
            value: _character,
            onChanged: (value) {
              print(value);
              setState(() {
                _selectedRadio = 0;
                _selectRadioBurttom(value, _selectedRadio);
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Resetear la lista'),
          leading: Radio(
            value: _character1,
            onChanged: (value) {
              setState(() {
                _selectedRadio = 1;
                _selectRadioBurttom(value, _selectedRadio);
                _character1 = !value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No hacer nada'),
          leading: Radio(
            autofocus: true,
            value: _character2,
            onChanged: (value) {
              setState(() {
                _selectedRadio = 2;
                _selectRadioBurttom(value, _selectedRadio);
                _character2 = !value;
              });
            },
          ),
        ),
      ],
    );
  }

  void _selectRadioBurttom(bool value, int option) {}
}
