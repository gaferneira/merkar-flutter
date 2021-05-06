import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/products/new_product/create_new_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/injection_container.dart';

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
            builder: (context, model, child) => ElasticInDown(
                  child: Scaffold(
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
                                  labelText: 'Buscar Actual...',
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
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          (viewModel.userProducts == null)
                              ? Text('Loading...')
                              : _showProductsList(viewModel.userProducts),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      tooltip: Strings.label_tootip_new_product,
                      child: Icon(Icons.add),
                      onPressed: () {
                        _createNewProduct(context);
                      },
                    ),
                  ),
                )));
  }

  Widget _showProductsList(List<Product>? userProducts) {
    return ListView.separated(
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
              viewModel.selectProduct(index, value!);
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
