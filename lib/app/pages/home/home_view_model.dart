import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/resources/strings.dart';
import '../../../data/entities/error/failures.dart';
import '../../../data/entities/shopping_list.dart';
import '../../../data/repositories/shopping_lists_repository.dart';
import '../shopping/shopping_list/shopping_list_page.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;

  HomePageViewModel(
      {required this.shoppingListsRepository});

  List<ShoppingList>? list;
  List? totalItems;
  List? totalSelected;
  String? error;

  void loadData() async {

    shoppingListsRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  Future <List<ListProduct>?> loadProducts(ShoppingList shoppingList) {
    return shoppingListsRepository.fetchProducts(shoppingList).first;
  }

  void saveList(String? name, BuildContext context) async {
    final result = await shoppingListsRepository.save(ShoppingList(name: name,
    total_items: '0',total_selected: '0'));
    Navigator.pop(context);
    result.fold(
            (failure) => {_mapFailureToMessage(failure)},
            (value) => {
          Navigator.pushNamed(
            context,
            ShoppingListPage.routeName,
            arguments: value,
          )
        });

  }

  Future <void> updateNameList( List<String> value)async {
    shoppingListsRepository.updateName(value[0], list![int.parse(value[1])]);
  }

  Future<void> removeList(int index) async{
    shoppingListsRepository.remove(list![index]);

  }
  
  Future<void> shareShoppingList(int index) async {
    String content='Pedido: ${list![index].name}\n';
    List<ListProduct>? productList = await loadProducts(list![index]);
    if(productList !=null && productList.length>0){
      for(int i=0;i<productList.length;i++) {
        content+='- ${productList[i].name} ${productList[i].quantity} ${productList[i].unit}(s)\n';
      }

    }
    Share.share(content);
  }

  Future<void> copyShoppingList(int index) async {
    copyList(index);
    List<ListProduct>? productList = await loadProducts(list![index]);
    if(productList!=null && productList.length>0) {
      for (int i = 0; i < productList.length; i++) {
        shoppingListsRepository.saveProduct(productList[i], list![index + 1]);
      }
    }
    notifyListeners();
  }

  void copyList(int index) async{
    final result = await shoppingListsRepository.save(ShoppingList(name: '${list![index].name} copy',
        total_items: '${list![index].total_items}',total_selected: '${list![index].total_selected}'));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Strings.SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return Strings.CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

}
