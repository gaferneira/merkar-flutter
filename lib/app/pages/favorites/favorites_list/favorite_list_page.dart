import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/favorites/select_my_favorites/select_my_favorites_page.dart';
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

class _FavoriteListPageState extends State<FavoriteListPage> {
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  FavoriteListViewModel viewModel = serviceLocator<FavoriteListViewModel>();

  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<FavoriteListViewModel>.value(
        value: viewModel,
        child: Consumer<FavoriteListViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
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
                                labelText: 'Buscar Actual...',
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
                  floatingActionButton: FloatingActionButton(
                    heroTag: "add_favorite",
                    onPressed: () => {_showListSuggerProducts(context)},
                    tooltip: Strings.label_tootip_add_products,
                    child: Icon(Icons.add),
                  ),
                )));
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
