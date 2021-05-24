import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/products/models/fab_menu.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/app/pages/products/select_products/select_products_page.dart';
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

class _ProductsListPageState extends State<ProductsListPage>
    with TickerProviderStateMixin {
  TextEditingController _searchTextController = TextEditingController();
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
      FabMenu(icon: Icons.favorite_border, action: () => _chooseFile(0)),
      FabMenu(icon: Icons.add, action: () => _chooseFile(1)),
    ];
  }

  void _chooseFile(int option) async {
    switch (option) {
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
                    title: Center(
                      child: Form(
                        key: _keySearchP,
                        child: Container(
                          width: 270,
                          height: 36,
                          child: TextField(
                            controller: _searchTextController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  color: Theme.of(context).primaryColor),
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 10),
                              fillColor: Colors.white,
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
                            onChanged: (value) => viewModel.searchByText(value),
                          ),
                        ),
                      ),
                    ),
                  ),
                  body: CustomScrollView(
                    slivers: (viewModel.userProducts == null ||
                            viewModel.userProducts!.isEmpty)
                        ? [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        height: 75.0,
                                        child: Text(Strings.products_no_items),
                                      ),
                                    ),
                                  );
                                },
                                childCount: 1,
                              ),
                              // : _showProductsList(viewModel.defaultProducts!),
                            )
                          ]
                        : _sliverList(viewModel.userProducts!),
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
                  transform:
                      Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
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

  List<Widget> _sliverList(List<Product> listProducts) {
    var productsMap = groupBy(listProducts, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys.sorted((a, b) => a!.compareTo(b!));
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList
        ..add(SliverAppBar(
          leading: Container(),
          title: Text(category),
          backgroundColor: Theme.of(context).primaryColor,
          pinned: true,
        ))
        ..add(SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            var product = products[index];
            return Dismissible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  decoration: AppStyles.checklistDecoration(
                      index.toDouble() / products.length),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        "${product.name}: ${product.unit} x ${product.price}",
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: Strings.label_edit,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CreateNewProduct.routeName,
                          arguments: product,
                        );
                      },
                    ),
                  ),
                ),
              ),
              background: Container(
                color: Colors.red,
                child: Icon(Icons.cancel),
              ),
              key: Key(product.id!),
              onDismissed: (direction) {
                viewModel.removeProduct(product);
              },
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: AppStyles.borderRadiusDialog,
                      // contentPadding: EdgeInsets.only(top: 10.0),
                      title: Center(child: const Text(Strings.confirm)),
                      content:
                          const Text("Estás seguro de eliminar el Elemento?"),
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
}
