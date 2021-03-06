import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/converString.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../select_my_products/select_my_products_page.dart';
import 'shopping_list_view_model.dart';

enum SingingCharacter { delete, reset, nothing }

class ShoppingListPage extends StatefulWidget {
  static const routeName = '/showselectlist';
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final keyFormEditProduct = GlobalKey<FormState>();
  final keyFormFinishShoppingList = GlobalKey<FormState>();
  final keyFormPurchaseList = GlobalKey<FormState>();
  ShoppingListViewModel viewModel = serviceLocator<ShoppingListViewModel>();
  int temp_quantity = null;
  double temp_price = null;
  String descriptionShoppingList = "";
  List<String> _textRadioButton = [
    "Eliminar Lista",
    "Restaurar lista",
    "No hacer nada"
  ];

  SingingCharacter _character = SingingCharacter.nothing;

  var _selectedId;
  String _selected;

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
                    title: Text(
                        ConvertString().capitalize('${shoppingList.name}')),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {
                          _showFinishDialog(shoppingList);
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
                              _showFinishDialog(shoppingList);
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

  void _saveEditProduct(ListProduct product) {
    if (keyFormEditProduct.currentState.validate()) {
      keyFormEditProduct.currentState.save();
      String oldTotal = product.total;
      product.quantity = this.temp_quantity;
      product.price = this.temp_price.toString();
      product.total = (this.temp_price * this.temp_quantity).toString();
      viewModel.updateProduct(product, oldTotal);
    }
  }

  Widget _showCircleRadioButtoms(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(_textRadioButton[0].toString()),
          leading: Radio(
            value: SingingCharacter.delete,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                print(_character);
              });
            },
          ),
        ),
        ListTile(
          title: Text(_textRadioButton[1].toString()),
          leading: Radio(
            value: SingingCharacter.reset,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                print(_character);
              });
            },
          ),
        ),
        ListTile(
          title: Text(_textRadioButton[2].toString()),
          leading: Radio(
            value: SingingCharacter.nothing,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                print(_character);
              });
            },
          ),
        ),
      ],
    );
  }

  void _showFinishDialog(ShoppingList shoppingList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: keyFormPurchaseList,
                child: Column(
                    // Then, the content of your dialog.
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: shoppingList.name +
                            " " +
                            DateTime.now().year.toString() +
                            "/" +
                            DateTime.now().month.toString() +
                            "/" +
                            DateTime.now().day.toString(),
                        decoration: InputDecoration(
                            labelText: Strings.label_description),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Llene la Descripción";
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          this.descriptionShoppingList = value;
                        },
                      ),
                      ListTile(
                        title: Text(_textRadioButton[0].toString()),
                        leading: Radio(
                          value: SingingCharacter.delete,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              print(_character);
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(_textRadioButton[1].toString()),
                        leading: Radio(
                          value: SingingCharacter.reset,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              print(_character);
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(_textRadioButton[2].toString()),
                        leading: Radio(
                          value: SingingCharacter.nothing,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              print(_character);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Constant.normalspace),
                        child: Center(
                          child: RaisedButton(
                              child: Text(Strings.label_finish),
                              onPressed: () {
                                _actionOnSaveList(shoppingList);
                              }),
                        ),
                      ),
                    ]),
              );
            },
          ),
        );
      },
    );
  }

  void _actionOnSaveList(ShoppingList shoppingList) {
    if (keyFormPurchaseList.currentState.validate()) {
      keyFormPurchaseList.currentState.save();
      viewModel.finishShopping(
          context, _character, descriptionShoppingList.toString());
    }
  }
}
