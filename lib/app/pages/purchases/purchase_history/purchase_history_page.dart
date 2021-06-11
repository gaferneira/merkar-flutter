import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'purchase_history_view_model.dart';
import '../purchase_history_show_info/purchase_history_show_info_page.dart';
import '../../../core/extensions/extended_string.dart';
import '../../../core/extensions/numberFormat.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/constants.dart';
import '../../../core/resources/strings.dart';
import '../../../widgets/confirmDismissDialog.dart';
import '../../../widgets/widgets.dart';
import '../../../../data/entities/purchase.dart';
import '../../../../injection_container.dart';

class PurchaseHistoryPage extends StatefulWidget {
  static const routeName = "/purchasehistory";
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  PurchaseHistoryViewModel viewModel =
      serviceLocator<PurchaseHistoryViewModel>();
  final _scaffKey = GlobalKey<ScaffoldState>();
  final keyFormPurchaseList = GlobalKey<FormState>();
  TextEditingController _text_searchController = TextEditingController();
  onItemChangedSelect(String value) {
    viewModel.list = viewModel.filterList!
        .where((shopping_list) =>
            shopping_list.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PurchaseHistoryViewModel>.value(
      //create: (context) => viewModel,
      value: viewModel,
      child: Consumer<PurchaseHistoryViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            title: Center(
              child: Form(
                key: keyFormPurchaseList,
                child: Container(
                  width: 270,
                  height: 36,
                  child: TextField(
                    controller: _text_searchController,
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
                    onChanged: onItemChangedSelect,
                  ),
                ),
              ),
            ),
          ),
          body: (viewModel.list != null)?
                SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                         purchaseHistoryDisplay(viewModel.list!),
                      ]),
                )
              : LoadingWidget(),
          ),
      ),
    );
  }

  Widget purchaseHistoryDisplay(List<Purchase> list) {
    if(list.isEmpty){
      return Center(child: Text(Strings.noCategoriesAvailable,
        textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,),
        widthFactor: 32.0,);
    }
        return listProducts(list);
  }

  Widget listProducts(List<Purchase> list) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: AppStyles.listDecoration(index.toDouble()/list.length),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(list[index].name!.capitalize() + ":",
                    textAlign: TextAlign.left,),
                    ),
                    Expanded(
                      child: Text(list[index].date!,
                        textAlign: TextAlign.center,),
                    ),
                    Text("\$ "+numberFormat(list[index].total!.toString()),
                      textAlign: TextAlign.right,),

                  ],
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PurchaseHistoryShowInfoPage.routeName,
                    arguments: list[index],
                  );
                },
              ),
            ),
          ),
          background: Container(
            color: Colors.red,
            child: Icon(Icons.cancel),
          ),
          key: Key(list[index].id!),
          onDismissed: (direction)  {
            onRemoveItem(list[index]);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(Strings.deleted)));

          },
          confirmDismiss: (DismissDirection)=>ConfirmDismissDialog(context, DismissDirection),
        );
      },
    );
  }

  void onRemoveItem(Purchase list) {
    viewModel.delete(list);
  }
}
