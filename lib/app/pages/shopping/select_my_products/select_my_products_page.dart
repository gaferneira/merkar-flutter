import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'select_my_products_view_model.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/constants.dart';
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
                    title: Center(
                      child: Form(
                        key: _keySearchP,
                        child: Container(
                          width: 270,
                          height: 36,
                          child: TextField(
                            controller: _search_textController,
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

  _createNewProduct(BuildContext context) {
    Navigator.of(context).pushNamed(CreateNewProduct.routeName);
  }
}
