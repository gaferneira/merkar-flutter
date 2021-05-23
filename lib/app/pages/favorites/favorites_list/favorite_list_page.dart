import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/favorites/select_my_favorites/select_my_favorites_page.dart';
import 'package:merkar/app/pages/favorites/widgets/fab_menu.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'favorite_list_view_model.dart';

enum SingingCharacter { delete, reset, nothing }

class FavoriteListPage extends StatefulWidget {
  static const routeName = '/showfavoritelist';
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> with
    TickerProviderStateMixin{
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  FavoriteListViewModel viewModel = serviceLocator<FavoriteListViewModel>();

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
        Navigator.of(context).pushNamed(SelectMyFavoritesPage.routeName);
        break;
      case 1:
        Navigator.of(context).pushNamed(CreateNewProduct.routeName);
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<FavoriteListViewModel>.value(
        value: viewModel,
        child: Consumer<FavoriteListViewModel>(
            builder: (context, model, child) => Scaffold(
              key: _scaffoldKey,
                  appBar: AppBar(
                    leading: Container(),
                    title: Text(Strings.route_favorites),
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
                          //_showFinishDialog(shoppingList);
                        },
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        (viewModel.userProducts == null || viewModel.userProducts!.isEmpty)
                            ? Text(Strings.noCategoriesAvailable)
                            : _showProductsList(viewModel.userProducts!),
                      ],
                    ),
                  ),
              floatingActionButton: AnimatedOpacity(
                opacity: _fabOpacity,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: _buildFabMenu(context),
              ),
                /*  floatingActionButton: FloatingActionButton(
                    heroTag: "add_favorite",
                    onPressed: () => {_showListSuggerProducts(context)},
                    tooltip: Strings.label_tootip_add_products,
                    child: Icon(Icons.add),
                  ),*/
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

  _showListSuggerProducts(BuildContext context) async {
    Navigator.of(context).pushNamed(SelectMyFavoritesPage.routeName);
  }

  Widget _showProductsList(List<Product> listProducts) {
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
            viewModel.removeProduct(viewModel.userProducts![index]);
            viewModel.userProducts!.removeAt(index);
            Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("$index Eliminado")));
            viewModel.notifyListeners();

          },

        );
      },
    );
  }

}
