import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merkar/app/core/extensions/number_format.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../injection_container.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/constants.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/products/new_product/create_new_product.dart';
import '../../../widgets/confirmDismissDialog.dart';
import '../../../widgets/primary_button.dart';
import '../select_my_products/select_my_products_page.dart';

import 'shopping_list_view_model.dart';


enum SingingCharacter { delete, reset, nothing }

class ShoppingListPage extends StatefulWidget {
  static const routeName = '/showselectlist';

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage>
    with TickerProviderStateMixin {
  final keyFormEditProduct = GlobalKey<FormState>();
  final keyFormFinishShoppingList = GlobalKey<FormState>();
  final keyFormPurchaseList = GlobalKey<FormState>();
  ShoppingListViewModel viewModel = serviceLocator<ShoppingListViewModel>();
  TextEditingController _search_textController = TextEditingController();
  final _keySearchFormUnsel = GlobalKey<FormState>();
  double temp_quantity = 1.0;
  double? temp_price = null;
  String? descriptionShoppingList = "";
  List<String> _textRadioButton = [
    Strings.delete_list,
    Strings.restore_list,
    Strings.do_nothing,
  ];

  SingingCharacter _character = SingingCharacter.nothing;
  ShoppingList shoppingList = new ShoppingList();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, FaIcon> categoriesIcons={
    "Verduras":FaIcon(FontAwesomeIcons.carrot,color: Colors.blueGrey,),
    "Frutas":FaIcon(FontAwesomeIcons.appleAlt,color: Colors.blueGrey),
    "Despensa": FaIcon(FontAwesomeIcons.doorClosed,color: Colors.blueGrey),
    "Carnes": FaIcon(FontAwesomeIcons.drumstickBite,color: Colors.blueGrey),
    "Lácteos y huevos":FaIcon(FontAwesomeIcons.egg,color: Colors.blueGrey),
    "Otros":FaIcon(FontAwesomeIcons.solidBookmark,color: Colors.blueGrey),
    "Panaderia":FaIcon(FontAwesomeIcons.breadSlice,color: Colors.blueGrey),
    "Aseo personal":FaIcon(FontAwesomeIcons.toiletPaper,color: Colors.blueGrey),
    "Aseo hogar":FaIcon(FontAwesomeIcons.soap,color: Colors.blueGrey),
    "Galletas y dulces":FaIcon(FontAwesomeIcons.cookie,color: Colors.blueGrey),
    "Bebidas":FaIcon(FontAwesomeIcons.tint,color: Colors.blueGrey),
    "Licores":FaIcon(FontAwesomeIcons.glassMartiniAlt,color: Colors.blueGrey),
    "Cerveza":FaIcon(FontAwesomeIcons.beer,color: Colors.blueGrey),
    "Mascotas":FaIcon(FontAwesomeIcons.dog,color: Colors.blueGrey),
    "Droguería":FaIcon(FontAwesomeIcons.medkit,color: Colors.blueGrey),
    "Hogar":FaIcon(FontAwesomeIcons.houseDamage,color: Colors.blueGrey),
    "Congelados":FaIcon(FontAwesomeIcons.solidSnowflake,color: Colors.blueGrey),
    "Vinos":FaIcon(FontAwesomeIcons.wineBottle,color: Colors.blueGrey),
    "Pasabocas":FaIcon(FontAwesomeIcons.candyCane,color: Colors.blueGrey),
    "Saludable":FaIcon(FontAwesomeIcons.seedling,color: Colors.blueGrey),
    "Aromáticas y espécias":FaIcon(FontAwesomeIcons.pepperHot,color: Colors.blueGrey),
    "Electrónica y electrodomésticos":FaIcon(FontAwesomeIcons.desktop,color: Colors.blueGrey),
    "Papelería":FaIcon(FontAwesomeIcons.paperclip,color: Colors.blueGrey),
    "Pescados y mariscos":FaIcon(FontAwesomeIcons.fish,color: Colors.blueGrey),
    "Ropa":FaIcon(FontAwesomeIcons.tshirt,color: Colors.blueGrey),
    "Salud y belleza":FaIcon(FontAwesomeIcons.airFreshener,color: Colors.blueGrey),
    "Libros y música":FaIcon(FontAwesomeIcons.bookOpen,color: Colors.blueGrey),
    "default":FaIcon(FontAwesomeIcons.solidBookmark,color: Colors.blueGrey),
  };

  onItemChanged(String value) {
    viewModel.selectedList = viewModel.filterselectedList!
        .where((shoppingList) =>
            shoppingList.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.unselectedList = viewModel.filterunselectedList!
        .where((shoppingList) =>
            shoppingList.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<ShoppingListViewModel>.value(
        value: viewModel,
        child: Consumer<ShoppingListViewModel>(
            builder: (context, model, child) => Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 0,top:3),
                        child: Form(
                          key: _keySearchFormUnsel,
                          child: SizedBox(
                            height: 36,
                            width: 250,
                            child: TextFormField(
                              controller: _search_textController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                                suffixIcon: _search_textController.text==null || _search_textController.text!="" ?
                                IconButton(icon: Icon(Icons.close)
                                  ,onPressed: (){
                                    setState(() {
                                      _search_textController.text="";
                                      onItemChanged("");
                                    });
                                  },)
                                    : null,
                                contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                                fillColor: MediaQuery.of(context).platformBrightness!=Brightness.dark?
                                Colors.white
                                :Colors.black12,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                hintText: Strings.label_search,
                              ),
                              onChanged: onItemChanged,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0,left: 5),
                        child: SizedBox(
                          width: 30.0,
                          child: IconButton(icon: Icon(Icons.share), onPressed: () {
                            viewModel.shareShoppingList();
                          },

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: PopupMenuButton(
                            icon: Icon(Icons.more_vert), // add this line
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  child: Container(
                                      width: 180.0,
                                      height: 17.0,
                                      child: Text(
                                        "Reiniciar",
                                      )
                                  ), value: 'reset'
                              ),
                              PopupMenuItem<String>(
                                  child: Container(
                                      width: 180.0,
                                      height: 19.0,
                                      child: Text(
                                        "Ordenar por Categoría",
                                      )
                                  ), value: 'category'
                              ),
                              PopupMenuItem<String>(
                                  child: Container(
                                      width: 180.0,
                                      height: 17.0,
                                      child: Text(
                                        "Ordenar Alfabéticamente",
                                      )
                                  ), value: 'name'
                              ),

                            ],
                            onSelected: (String action_select) async {
                              switch (action_select) {
                                case 'reset':
                                  _resetShoppingList(context);
                                  break;
                                case 'name':
                                case 'category':
                                  _sortListProductsBy(action_select);
                                  break;
                              }
                            }
                        ),
                      ),

                    ],
                  ),
                  body: SingleChildScrollView(

                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: AppStyles.primaryBoxDecorationStyle,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.list_alt),
                                Padding(
                                  padding: const EdgeInsets.all(Constant.normalspace),
                                  child: Center(
                                      child: Text(Strings.in_list,
                                        style: AppStyles.resalt_text,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (viewModel.unselectedList == null)
                            ? LoadingWidget()
                            : _showProductsList(viewModel.unselectedList!),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: AppStyles.primaryBoxDecorationStyle,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart),
                                Padding(
                                  padding: const EdgeInsets.all(Constant.normalspace),
                                  child: Center(
                                      child: Text(Strings.car,
                                        style: AppStyles.resalt_text,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (viewModel.selectedList == null)
                            ? LoadingWidget()
                            : _showSelectProductsList(viewModel.selectedList!),
                        PrimaryButton(
                            enable: (viewModel.selectedList==null)? false : viewModel.selectedList!.isNotEmpty,
                            title: Strings.label_finish,
                            onPressed: () {
                              _showFinishDialog(shoppingList);
                            }),
                      ],
                    ),
                  ),
                  floatingActionButton: Pulse(
                      infinite: true,
                      child: FloatingActionButton(
                        heroTag: "add_product",
                        onPressed: () =>
                        {_showListSuggerProducts(context, shoppingList)},
                        tooltip: Strings.label_tootip_add_products,
                        child: Icon(Icons.add),
                      ),
                    ),
                  bottomNavigationBar: Container(
                      height: Constant.bottomBarHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).colorScheme.primaryVariant, spreadRadius: 3),
                        ],
                      ),
                      child: BottomNavigationBar(
                        fixedColor: Colors.white70,
                        unselectedItemColor: Colors.white70,
                        elevation: 5,
                        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                        currentIndex: 1,
                        type: BottomNavigationBarType.fixed,
                        // this will be set when a new tab is tapped
                        items: [
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.list_alt),
                            label: '\$ '+numberFormat((double.parse(viewModel.totalPrice())-double.parse(viewModel.totalShopping())).toString()),

                          ),
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.shopping_cart),
                            label:'\$ ${numberFormat(viewModel.totalShopping())}',

                          ),
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.stacked_bar_chart),
                            label:'\$ ${numberFormat(viewModel.totalPrice())}',
                            backgroundColor: Colors.white,
                          ),
                        ],
                      )),
                )));
  }
  _showListSuggerProducts(
      BuildContext context, ShoppingList? shoppingList) async {
    Navigator.of(context)
        .pushNamed(SelectMyProductsPage.routeName, arguments: shoppingList);
  }

  Widget _showProductsList(List<ListProduct> listProducts) {
    if(listProducts.isEmpty){
      return  Center(
        child: Padding(
          padding: const EdgeInsets.all(Constant.normalspacecontainer),
          child: Text(
            Strings.products_no_items_shopping_list,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      //scroll the listView
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listProducts.length,
      itemBuilder: (context, index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 7, top: 1, bottom: 1),
            child: Container(
              decoration: AppStyles.checklistDecoration(
                  index.toDouble() / listProducts.length),
              child: CheckboxListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.only(right: 0.0,left: 0.0,top: 0.0,bottom: 15.0),
                      child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: categoriesIcons['${listProducts[index].category!}']!=null?
                          categoriesIcons['${listProducts[index].category!}']:
                          categoriesIcons['default']
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${listProducts[index].name}",
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "${listProducts[index].quantity} ${listProducts[index].unit} a \$ ${numberFormat(listProducts[index].price)}"),
                            ],
                          ),
                          showChangeCuantity(listProducts[index].quantity,listProducts[index].id!),
                        ],
                      ),
                    ),

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
              ),
            ),
          ),
          background: Container(
            color: Colors.red,
            child: Icon(Icons.cancel),
          ),
          key: Key(listProducts[index].id!),
          onDismissed: (direction) {
            viewModel.removeProduct(listProducts[index].id!, shoppingList);
            listProducts.removeAt(index);
            _search_textController.text="";
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(Strings.deleted)));
            viewModel.notifyListeners();
          },
          confirmDismiss: (DismissDirection)=>ConfirmDismissDialog(context, DismissDirection),
        );
      },
    );
  }

  Widget _showSelectProductsList(List<ListProduct> listProducts) {
    if(listProducts.isEmpty){
      return Padding(
        padding: const EdgeInsets.all(Constant.normalspacecontainer),
        child: Text(Strings.add_products_from_list),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listProducts.length,
      itemBuilder: (context, index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 7, top: 1, bottom: 1),
            child: Container(
              decoration: AppStyles.checklistDecoration(
                  index.toDouble() / listProducts.length),
              child: CheckboxListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.only(right: 0.0,left: 0.0,top: 0.0,bottom: 15.0),
                      child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: categoriesIcons['${listProducts[index].category!}']!=null?
                          categoriesIcons['${listProducts[index].category!}']:
                          categoriesIcons['default']
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${listProducts[index].name}",
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "${listProducts[index].quantity} ${listProducts[index].unit} = "
                                      "\$ ${numberFormat((listProducts[index].quantity*double.parse(listProducts[index].price)).toString())}"),
                            ],
                          ),
                          showChangeCuantity(listProducts[index].quantity,listProducts[index].id!),
                        ],
                      ),
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  if (value == true)
                    viewModel.selectProduct(index);
                  else {
                    viewModel.unselectProduct(index);
                  }
                },
                secondary: IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: Strings.label_edit,
                  onPressed: () {
                    _showEditProduct(listProducts[index], context);
                  },
                ),
                value: listProducts[index].selected,
               // activeColor: Colors.cyan,
                // checkColor: Colors.green,
              ),
            ),
          ),
          key: Key(listProducts[index].id!),
          background: Container(color: Colors.red, child: Icon(Icons.cancel)),
          onDismissed: (direction) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(Strings.deleted)));
            viewModel.removeProduct(listProducts[index].id!, shoppingList);
            listProducts.removeAt(index);
          },
          confirmDismiss: (DismissDirection)=>ConfirmDismissDialog(context, DismissDirection),
        );
      },
    );
  }

  Future<void> _showEditProduct(
      ListProduct product, BuildContext context) async {
    switch (await showDialog(
      context: context,
      builder: (context) => Container(
          height:368.0,
          child: AlertDialog(
            shape: AppStyles.borderRadiusDialog,
            title: Center(child: Text(Strings.editProductTittle + " ${product.name}")),
            content: Form(
              key: keyFormEditProduct,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: "${product.quantity}",
                      decoration: InputDecoration(labelText: Strings.label_quantity+ " en "+product.unit!),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isNotEmpty == true) {
                          return null;
                        } else
                          return Strings.error_required_field;
                      },
                      onSaved: (value) {
                        this.temp_quantity = double.parse(value!);
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
                          return Strings.error_required_field;
                      },
                      onSaved: (value) {
                        this.temp_price = double.parse(value!);
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    Center(
                      child: PrimaryButton(title: Strings.label_save,onPressed: () {
                        _saveEditProduct(product);
                        Navigator.pop(context, "${Strings.label_save}");
                      }),

                    ),
                  ],
                ),
              ),
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

  void _showFinishDialog(ShoppingList? shoppingList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return AlertDialog(
          shape: AppStyles.borderRadiusDialog,
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: keyFormPurchaseList,
                  child: Column(
                      // Then, the content of your dialog.
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: shoppingList!.name!,
                          decoration: InputDecoration(
                              labelText: Strings.label_description),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value?.isNotEmpty == true) {
                              return null;
                            } else
                              return Strings.error_required_field;
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
                                });
                              }
                            },
                          ),
                        ),
                        Center(
                          child: PrimaryButton(
                              title: Strings.label_finish,
                              onPressed: () {
                                _actionOnSaveList(shoppingList);
                              }),
                        ),
                      ]),
                ),
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
  void _resetShoppingList(BuildContext context){
    viewModel.resetShoppingList();
    //_scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(Strings.reseted)));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.reseted)));
  }

  void _sortListProductsBy(String option){
    switch (option){
      case 'name':
        viewModel.unselectedList!.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        viewModel.selectedList!.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        break;
      case 'category':
        viewModel.unselectedList!.sort((a, b) => a.category!.toLowerCase().compareTo(b.category!.toLowerCase()));
        viewModel.selectedList!.sort((a, b) => a.category!.toLowerCase().compareTo(b.category!.toLowerCase()));
        break;
    }
    viewModel.notifyListeners();
  }
  Widget showChangeCuantity(double quantity, String id) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 38.0,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white54,
          boxShadow: [
            BoxShadow(color: Colors.blueGrey, spreadRadius: 1),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.center,
                child: IconButton(icon: Icon(Icons.remove),onPressed: (){
                  if(quantity==0.5){
                    null;
                  }
                  else{
                    quantity=quantity-0.5;
                    viewModel.updateQuantity(quantity,id);
                  }
                },color: quantity==0.5?Colors.white:Colors.red,)),
            Text("${quantity}"),
            IconButton(icon: Icon(Icons.add),onPressed: (){
              quantity=quantity+0.5;
              viewModel.updateQuantity(quantity,id);
            },
              color:Colors.green,
            ),
          ],),
      ),
    );
  }
}
