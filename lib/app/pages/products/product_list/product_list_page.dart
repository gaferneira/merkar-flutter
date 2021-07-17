import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merkar/app/core/extensions/numberFormat.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/products/new_product/create_new_product.dart';
import '../../../pages/products/select_products/select_products_page.dart';
import '../../../pages/products/widgets/fab_menu.dart';
import '../../../widgets/confirmDismissDialog.dart';
import '../../../../data/entities/product.dart';
import '../../../../injection_container.dart';
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

  //floating buttons
  late AnimationController _controller;
  late List<FabMenu> fabItems;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

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
          builder: (context, model, child) =>
              Scaffold(
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
                                color: Theme
                                    .of(context)
                                    .primaryColor),
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
                    slivers: (viewModel.userProducts == null)
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
    Color backgroundColor = Theme
        .of(context)
        .cardColor;
    Color foregroundColor = Theme
        .of(context)
        .accentColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(fabItems.length, (int index) {
        Widget child = new Container(
          padding: EdgeInsets.only(bottom: 10),
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
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
    if(listProducts.isEmpty){
      return [
        SliverFillRemaining(
            child:Center(child:Padding(
                padding: const EdgeInsets.all(40),
                child: Text(Strings.products_no_items,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,)
            ))
        ),
      ];
    }
    var productsMap = groupBy(listProducts, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys.sorted((a, b) => a!.compareTo(b!));
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList..add(SliverAppBar(
        pinned: false,
        snap: true,
        floating: true,
        expandedHeight: 40.0,
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ))..add(SliverFixedExtentList(
        itemExtent: 50.0,
        delegate:
        SliverChildBuilderDelegate((BuildContext context, int index) {
          var product = products[index];
          return Dismissible(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: AppStyles.checklistDecoration(
                    index.toDouble() / products.length),
                child: ListTile(
                  title: Center(
                    child: Text(
                      "${product.name}: ${product.unit} x ${numberFormat(product.price)}",
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
              _searchTextController.text="";
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
}