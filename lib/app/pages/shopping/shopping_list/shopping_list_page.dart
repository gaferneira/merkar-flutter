import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
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
  TextEditingController _text_searchController = TextEditingController();
  final _keySearchFormUnsel = GlobalKey<FormState>();
  int temp_quantity = 1;
  double? temp_price = null;
  String? descriptionShoppingList = "";
  List<String> _textRadioButton = [
    "Eliminar Lista",
    "Restaurar lista",
    "No hacer nada"
  ];

  SingingCharacter _character = SingingCharacter.nothing;

  var _selectedId;
  String? _selected;

  onItemChangedSelect(String value) {
    viewModel.selectedList = viewModel.filterselectedList
        .where((shopping_list) =>
            shopping_list.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.unselectedList = viewModel.filterunselectedList
        .where((shopping_list) =>
            shopping_list.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList =
        ModalRoute.of(context)!.settings.arguments as ShoppingList;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<ShoppingListViewModel?>.value(
        value: viewModel,
        child: Consumer<ShoppingListViewModel>(
            builder: (context, model, child) => ElasticIn(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                          ConvertString().capitalize('${shoppingList.name}')),
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(Constant.normalspace),
                          child: Form(
                            key: _keySearchFormUnsel,
                            child: SizedBox(
                              height: 30,
                              width: 270,
                              child: TextFormField(
                                controller: _text_searchController,
                                decoration: InputDecoration(
                                  labelText: "Buscar ...",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onChanged: onItemChangedSelect,
                              ),
                            ),
                          ),
                        ),
                        Bounce(
                          child: IconButton(
                            icon: Icon(Icons.check_circle),
                            onPressed: () {
                              _showFinishDialog(shoppingList);
                            },
                          ),
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(Constant.normalspace),
                            child: Center(
                                child: Text(
                              "No seleccionados",
                              style: Constant.resaltText,
                            )),
                          ),
                          (viewModel.unselectedList == null)
                              ? Text(
                                  'Loading...',
                                  style: Constant.resaltText,
                                )
                              : _showProductsList(viewModel.unselectedList),
                          Padding(
                            padding: const EdgeInsets.all(Constant.normalspace),
                            child: Center(
                                child: Text(
                              "Seleccionados",
                              style: Constant.resaltText,
                            )),
                          ),
                          (viewModel.selectedList == null)
                              ? Text('Loading...')
                              : _showSelectProductsList(viewModel.selectedList),
                          RaisedButton(
                              child: Text(Strings.label_finish),
                              color: Constant.lightColor,
                              textColor: Constant.textColorButtomLight,
                              shape: Constant.borderRadius,
                              onPressed: () {
                                _showFinishDialog(shoppingList);
                              }),
                        ],
                      ),
                    ),
                    floatingActionButton: Pulse(
                      infinite: true,
                      child: FloatingActionButton(
                        onPressed: () =>
                            {_showListSuggerProducts(context, shoppingList)},
                        tooltip: Strings.label_tootip_add_products,
                        child: Icon(Icons.add),
                      ),
                    ),
                    bottomNavigationBar: Container(
                        height: Constant.bottomBarHeight,
                        width: MediaQuery.of(context).size.width,
                        child: BottomNavigationBar(
                          fixedColor: Colors.white70,
                          unselectedItemColor: Colors.white70,
                          backgroundColor: Colors.black45,
                          currentIndex:
                              1, // this will be set when a new tab is tapped
                          items: [
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.insert_chart),
                              title:
                                  Text('Total: \$ ${viewModel.totalPrice()}'),
                              backgroundColor: Colors.white,
                            ),
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.shopping_cart),
                              title: new Text(
                                  'Carrito (\$ ${viewModel.totalShopping()})'),
                            ),
                          ],
                        )),
                  ),
                )));
  }

  _showListSuggerProducts(
      BuildContext context, ShoppingList? shoppingList) async {
    Navigator.of(context)
        .pushNamed(SelectMyProductsPage.routeName, arguments: shoppingList);
  }

  Widget _showProductsList(List<ListProduct> listProducts) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      //scroll the listView
      physics: const NeverScrollableScrollPhysics(),
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
                      "${listProducts[index].quantity} a \$ ${listProducts[index].price}"),
                ],
              )
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
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
          onChanged: (bool? value) {
            if (value == true)
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
                  if (value?.isNotEmpty == true) {
                    return null;
                  } else
                    return "Ingrese la cantidad";
                },
                onSaved: (value) {
                  this.temp_quantity = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: "${product.price}",
                decoration: InputDecoration(labelText: Strings.label_price),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isNotEmpty == true) {
                    return null;
                  } else
                    return "Ingrese un valor";
                },
                onSaved: (value) {
                  this.temp_price = double.parse(value!);
                },
                textInputAction: TextInputAction.done,
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
    if (keyFormEditProduct.currentState?.validate() == true) {
      keyFormEditProduct.currentState!.save();
      String? oldTotal = product.total;
      product.quantity = this.temp_quantity;
      product.price = this.temp_price.toString();
      product.total = (this.temp_price! * this.temp_quantity).toString();
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
            onChanged: (SingingCharacter? value) {
              if (value != null) {
                setState(() {
                  _character = value;
                });
              }
            },
          ),
        ),
        ListTile(
          title: Text(_textRadioButton[1].toString()),
          leading: Radio(
            value: SingingCharacter.reset,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              if (value != null) {
                setState(() {
                  _character = value;
                  print(_character);
                });
              }
            },
          ),
        ),
        ListTile(
          title: Text(_textRadioButton[2].toString()),
          leading: Radio(
            value: SingingCharacter.nothing,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              if (value != null) {
                setState(() {
                  _character = value;
                  print(_character);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void _showFinishDialog(ShoppingList? shoppingList) {
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
                        initialValue: shoppingList!.name! +
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
                          if (value?.isNotEmpty == true) {
                            return null;
                          } else
                            return "Llene la Descripción";
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
                          onChanged: (SingingCharacter? value) {
                            if (value != null) {
                              setState(() {
                                _character = value;
                                print(_character);
                              });
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(_textRadioButton[1].toString()),
                        leading: Radio(
                          value: SingingCharacter.reset,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            if (value != null) {
                              setState(() {
                                _character = value;
                                print(_character);
                              });
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(_textRadioButton[2].toString()),
                        leading: Radio(
                          value: SingingCharacter.nothing,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            if (value != null) {
                              setState(() {
                                _character = value;
                                print(_character);
                              });
                            }
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

  void _actionOnSaveList(ShoppingList? shoppingList) {
    if (keyFormPurchaseList.currentState?.validate() == true) {
      keyFormPurchaseList.currentState!.save();
      viewModel.finishShopping(
          context, _character, descriptionShoppingList.toString());
    }
  }
}
