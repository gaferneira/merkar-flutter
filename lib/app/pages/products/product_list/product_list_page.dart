import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/products/select_products/select_products_page.dart';
import 'package:merkar/app/pages/products/widgets/fab_menu.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';
import 'product_list_view_model.dart';

enum SingingCharacter { delete, reset, nothing }

class ProductsListPage extends StatefulWidget {
  static const routeName = '/showfavoritelist';
  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> with
    TickerProviderStateMixin{
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  ProductsListViewModel viewModel = serviceLocator<ProductsListViewModel>();

  late AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _buildFabMenus();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  late List<FabMenu> fabItems;
  void _buildFabMenus() {
    fabItems = [
      FabMenu(
          icon: Icons.favorite_border,
          action: () => _chooseFile(0)),
      FabMenu(
          icon: Icons.add,
          action: () => _chooseFile(1)),
    ];
  }
  void _chooseFile(int option) async {
    switch (option){
      case 0:
        Navigator.of(context).pushNamed(SelectProductsPage.routeName);
        break;
      case 1:
        Navigator.of(context).pushNamed(CreateNewProduct.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<ProductsListViewModel>.value(
        value: viewModel,
        child: Consumer<ProductsListViewModel>(
            builder: (context, model, child) => Scaffold(
              key: _scaffoldKey,
                  appBar: AppBar(
                    leading: Container(),
                    title: Text(Strings.route_products),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(Constant.normalspace),
                        child: Form(
                          key: _keySearchP,
                          child: SizedBox(
                            height: 30,
                            width: 270,
                            child: TextField(
                              controller: _search_textController,
                              decoration: InputDecoration(
                                labelText: 'Buscar',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              textDirection: TextDirection.ltr,
                              onChanged: onItemChanged,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                  body: CustomScrollView(
                      slivers:(viewModel.userProducts == null || viewModel.userProducts!.isEmpty) ? [SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.blue[200],
                                  height: 75.0,
                                  child: Text(Strings.products_no_items),
                                ),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                        // : _showProductsList(viewModel.defaultProducts!),
                      )]: _sliverList(viewModel.userProducts!),
                  ),
              floatingActionButton: AnimatedOpacity(
                opacity: _fabOpacity,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: _buildFabMenu(context),
              ),
                )));
  }
  double _fabOpacity = 1;

  Widget _buildFabMenu(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(fabItems.length, (int index) {
        Widget child = new Container(
          padding: EdgeInsets.only(bottom: 10),
          // height: 70.0,
          // width: 56.0,
          //alignment: FractionalOffset.bottomRight,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              //   curve: new Interval(
              //       1.0 * index / 10.0, 1.0 - index / fabItems.length / 2.0,
              //       curve: Curves.fastOutSlowIn),
              curve: Curves.fastOutSlowIn,
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: false,
              child: new Icon(fabItems[index].icon, color: foregroundColor),
              onPressed: () {
                fabItems[index].action();
                _controller.reverse();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return new Transform(
                  transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.menu : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }

  onItemChanged(String value) {
    viewModel.userProducts = viewModel.filterUserProducts
        .where((product) =>
            product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  List<Widget> _sliverList(List<Product> listProducts) {
    var productsMap = groupBy(listProducts, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys;
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList..add(SliverAppBar(
        leading: Container(),
        title: Text(category),
        pinned: true,
      ))..add(SliverFixedExtentList(
        itemExtent: 50.0,
        delegate:
        SliverChildBuilderDelegate((BuildContext context, int index) {
          return Dismissible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: AppStyles.listDecoration(index.toDouble()/products.length),
                child: ListTile(

                  title: Center(
                    child: Text(
                      "${products[index].name}: ${products[index].unit} x ${products[index].price}",
                    ),
                  ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: Strings.label_edit,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      CreateNewProduct.routeName,
                      arguments: products[index],
                    );
                  },
                ),
                ),
              ),
            ),
            background: Container(color: Colors.red,child: Icon(Icons.cancel),),
            key: Key(listProducts[index].id!),
            onDismissed: (direction){
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(Strings.deleted)));
              viewModel.userProducts!.remove(products[index]);
              viewModel.removeProduct(products[index]);
            },
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: AppStyles.borderRadiusDialog,
                    // contentPadding: EdgeInsets.only(top: 10.0),
                    title: Center(child: const Text(Strings.confirm)),
                    content: const Text("Estás seguro de eliminar el Elemento?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(Strings.calcel),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(Strings.delete)),
                    ],
                  );
                },
              );
            },

          );
        }, childCount: products.length),
      ));
    }
    return widgetList;
  }
  /* Widget _showProductsList(List<Product> listProducts) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listProducts.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: AppStyles.listDecoration(index.toDouble()/listProducts.length),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${listProducts[index].name}",
                    ),
                    Text("\$ ${listProducts[index].price}"),
                  ],
                ),
              ),
            ),
          ),
          background: Container(color: Colors.red,child: Icon(Icons.cancel),),
          key: Key(listProducts[index].id!),
          onDismissed: (direction){
            Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("Eliminado")));
            viewModel.removeProduct(viewModel.userProducts![index]);
            viewModel.userProducts!.removeAt(index);
            viewModel.notifyListeners();
          },
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: AppStyles.borderRadiusDialog,
                  // contentPadding: EdgeInsets.only(top: 10.0),
                  title: Center(child: const Text(Strings.confirm)),
                  content: const Text("Estás seguro de eliminar el Elemento?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(Strings.calcel),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(Strings.delete)),
                  ],
                );
              },
            );
          },

        );
      },
    );
  }*/

}
