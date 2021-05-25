import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'select_my_products_view_model.dart';

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

  onItemChanged(String value) {
    viewModel.userProducts = viewModel.filteruserProducts!
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
                    title: Text(Strings.title_my_products),
                    actions: [
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
                                //hintText: ,
                              ),
                              onChanged: onItemChanged,
                            ),
                          ),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    ],
                  ),
                 /* body: SingleChildScrollView(
                    child: Column(
                      children: [
                        (viewModel.userProducts == null)
                            ? Text('Loading...')
                            : _showProductsList(viewModel.userProducts),
                      ],
                    ),
                  ),*/
              body: CustomScrollView(
                  slivers: (viewModel.userProducts == null)
                  ? [
                  SliverList(
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
                  )
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
    var productsMap = groupBy(list, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys.sorted((a, b) => a!.compareTo(b!));
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList
        ..add(SliverAppBar(
          leading: Container(),
          title: Text(category),
          pinned: true,
        ))
        ..add(SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
            );
          }, childCount: products.length),
        ));
    }
    return widgetList;
  }

  Widget _showProductsList(List<Product>? userProducts) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: userProducts?.length ?? 0,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text("${userProducts![index].name}"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              viewModel.selectProduct(index,userProducts[index] ,value!);
            },
            value: userProducts[index].selected,
            activeColor: Colors.cyan,
            checkColor: Colors.green,
          );
        });
  }

  _createNewProduct(BuildContext context) {
    Navigator.of(context).pushNamed(CreateNewProduct.routeName);
  }
}
