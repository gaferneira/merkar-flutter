import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merkar/app/widgets/confirmDismissDialog.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'select_my_products_view_model.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/products/new_product/create_new_product.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../injection_container.dart';




class SelectMyProductsPage extends StatefulWidget {
  static const routeName = "/select_my_products_page";

  @override
  _SelectMyProductsPageState createState() => _SelectMyProductsPageState();
}

class _SelectMyProductsPageState extends State<SelectMyProductsPage> {
  SelectMyProductsViewModel viewModel =
      serviceLocator<SelectMyProductsViewModel>();
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  late ShoppingList shoppingList;

  Map<String, FaIcon> categoriesIcons={
    "Verduras":FaIcon(FontAwesomeIcons.carrot,color: Colors.white,),
    "Frutas":FaIcon(FontAwesomeIcons.appleAlt,color: Colors.white),
    "Despensa": FaIcon(FontAwesomeIcons.doorClosed,color: Colors.white),
    "Carnes": FaIcon(FontAwesomeIcons.drumstickBite,color: Colors.white),
    "Lácteos y huevos":FaIcon(FontAwesomeIcons.egg,color: Colors.white),
    "Otros":FaIcon(FontAwesomeIcons.solidBookmark,color: Colors.white),
    "Panaderia":FaIcon(FontAwesomeIcons.breadSlice,color: Colors.white),
    "Aseo personal":FaIcon(FontAwesomeIcons.toiletPaper,color: Colors.white),
    "Aseo hogar":FaIcon(FontAwesomeIcons.soap,color: Colors.white),
    "Galletas y dulces":FaIcon(FontAwesomeIcons.cookie,color: Colors.white),
    "Bebidas":FaIcon(FontAwesomeIcons.tint,color: Colors.white),
    "Licores":FaIcon(FontAwesomeIcons.glassMartiniAlt,color: Colors.white),
    "Cerveza":FaIcon(FontAwesomeIcons.beer,color: Colors.white),
    "Mascotas":FaIcon(FontAwesomeIcons.dog,color: Colors.white),
    "Droguería":FaIcon(FontAwesomeIcons.medkit,color: Colors.white),
    "Hogar":FaIcon(FontAwesomeIcons.houseDamage,color: Colors.white),
    "Congelados":FaIcon(FontAwesomeIcons.solidSnowflake,color: Colors.white),
    "Vinos":FaIcon(FontAwesomeIcons.wineBottle,color: Colors.white),
    "Pasabocas":FaIcon(FontAwesomeIcons.candyCane,color: Colors.white),
    "Saludable":FaIcon(FontAwesomeIcons.seedling,color: Colors.white),
    "Aromáticas y espécias":FaIcon(FontAwesomeIcons.pepperHot,color: Colors.white),
    "Electrónica y electrodomésticos":FaIcon(FontAwesomeIcons.desktop,color: Colors.white),
    "Papelería":FaIcon(FontAwesomeIcons.paperclip,color: Colors.white),
    "Pescados y mariscos":FaIcon(FontAwesomeIcons.fish,color: Colors.white),
    "Ropa":FaIcon(FontAwesomeIcons.tshirt,color: Colors.white),
    "Salud y belleza":FaIcon(FontAwesomeIcons.airFreshener,color: Colors.white),
    "Libros y música":FaIcon(FontAwesomeIcons.bookOpen,color: Colors.white),
    "default":FaIcon(FontAwesomeIcons.solidBookmark,color: Colors.white),
  };
  onItemChanged(String value) {
    viewModel.userProducts = viewModel.filterUserProducts!
        .where((product) =>
            product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;
    viewModel.loadData(shoppingList);

    return ChangeNotifierProvider<SelectMyProductsViewModel>.value(
        value: viewModel,
        child: Consumer<SelectMyProductsViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Center(
                      child: Form(
                        key: _keySearchP,
                        child: Container(
                          width: 270,
                          height: 36,
                          child: TextField(
                            autofocus: true,
                            controller: _search_textController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
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
                  ),
              body: CustomScrollView(
                  slivers: (viewModel.userProducts == null )
                  ? [
                  SliverFillRemaining(
                      child:Center(child:Padding(
                          padding: const EdgeInsets.all(40),
                          child: LoadingWidget(),
                      ))
                  ),
                  ]
                      : _sliverList(viewModel.userProducts!),
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
  List<Widget> _sliverList(List<Product> list) {
    if (viewModel.userProducts!.isEmpty){
      return [
        SliverFillRemaining(
            child:Center(child:Padding(
                padding: const EdgeInsets.all(40),
                child: Text(Strings.select_products_no_items,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,)
            ))
        ),
      ];
    }
    var productsMap = groupBy(list, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys.sorted((a, b) => a!.compareTo(b!));
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList
        ..add(SliverAppBar(
          leading: Container(),
          title: Row(
            children: [
              Padding(
                padding:  const EdgeInsets.only(right: 0.0,left: 0.0,top: 0.0,bottom: 8.0),
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child:categoriesIcons['$category']!=null?
                  categoriesIcons['$category']:
                  categoriesIcons['default'],
                ),
              ),
              SizedBox(
                  width:20.0
              ),
              Text(category),
            ],
          ),
          pinned: false,
        ))
        ..add(SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return Dismissible(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  decoration: AppStyles.checklistDecoration(
                      index.toDouble() / products.length),
                  child: CheckboxListTile(
                      title: Text(
                          "${products[index].name}: ${products[index].unit} x ${products[index].price}"),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        viewModel.selectProduct(index, products[index],value!);
                      },
                      value: products[index].selected,
                    activeColor: Colors.cyan,
                    checkColor: Colors.green,),
                ),
              ),
              background: Container(
                color: Colors.red,
                child: Icon(Icons.cancel),
              ),
              key: Key(products[index].id!),
              onDismissed: (direction) {
                viewModel.removeProduct(products[index]);
                _search_textController.text="";
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(Strings.deleted)));
              },
              confirmDismiss: (DismissDirection) =>
                  ConfirmDismissDialog(context, DismissDirection),
            );
          }, childCount: products.length),
        ));
    }
    return widgetList;
  }

  _createNewProduct(BuildContext context) {
    Navigator.of(context).pushNamed(CreateNewProduct.routeName);
  }
}
