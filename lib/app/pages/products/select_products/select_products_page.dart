import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'select_products_view_model.dart';

class SelectProductsPage extends StatefulWidget {
  static const routeName = "/select_products_page";

  @override
  _SelectProductsPageState createState() => _SelectProductsPageState();
}

class _SelectProductsPageState extends State<SelectProductsPage> {
  SelectProductsViewModel viewModel =
      serviceLocator<SelectProductsViewModel>();
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<SelectProductsViewModel>.value(
        value: viewModel,
        child: Consumer<SelectProductsViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.title_sugger_products),
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
                  body: CustomScrollView(
                    slivers:(viewModel.defaultProducts == null) ? [SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return LoadingWidget();
                        },
                        childCount: 1,
                      ),
                       // : _showProductsList(viewModel.defaultProducts!),
                  )]: _sliverList(viewModel.defaultProducts!),
            )))
    );
  }

  onItemChanged(String value) {
    viewModel.defaultProducts = viewModel.filterDefaultProducts!
        .where((product) =>
            product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  List<Widget> _sliverList(List<Product> list) {
    var productsMap = groupBy(list, (Product obj) => obj.category);
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
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: AppStyles.listDecoration(index.toDouble()/products.length),
              child: CheckboxListTile(
                title: Text("${products[index].name}"),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  viewModel.selectProduct(products[index], value == true);
                },
                value: products[index].selected
              ),
            ),
          );
        }, childCount: products.length),
      ));
    }
    return widgetList;
  }

}
