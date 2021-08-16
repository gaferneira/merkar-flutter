import 'package:flutter/material.dart';
import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/products_repository.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';

class SelectMyProductsViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListRepository;
  final ProductsRepository productsRepository;

  SelectMyProductsViewModel(
      {required this.shoppingListRepository, required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? userProducts;
  List<Product>? filterUserProducts;
  List<ListProduct>? shoppingProducts;

  String? error;

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;

    // Get user products
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
      filterUserProducts = userProducts;
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

    // Get shopping list products
    shoppingListRepository.fetchProducts(shoppingList).listen((data) {
      shoppingProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void updateList() {
    if (shoppingProducts != null && userProducts != null) {
      userProducts!.forEach((product) {
        product.selected = false;
      });

      shoppingProducts?.forEach((product) {
        userProducts?.forEach((userProduct) {
          if (product.id == userProduct.id) {
            userProduct.selected = true;
          }
        });
      });
    }

    notifyListeners();
  }

  Future<void> selectProduct(int index, Product product,bool selected) async {
    //var product = userProducts![index];
    userProducts![index].selected=selected;
    if (selected) {
      var productList = ListProduct(
          id: product.id,
          category: product.category,
          name: product.name,
          price: product.price,
          quantity: 1,
          total: product.price,
          unit: product.unit,
          selected: false);
      shoppingList.total_items= (int.parse(shoppingList.total_items!)+1).toString();
      shoppingListRepository.saveProduct(productList, shoppingList);
      shoppingProducts!.add(productList);
    } else {
      shoppingList.total_items= (int.parse(shoppingList.total_items!)-1).toString();
      shoppingListRepository.removeProduct(product.id!, shoppingList);
      ListProduct p= shoppingProducts!.where((element) => element.id==product.id!).first;
    }
    shoppingListRepository.updateTotalItems(shoppingList.total_items!, shoppingList);
    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    userProducts?.remove(product);
    productsRepository.remove(product);
    notifyListeners();
  }
   double getQuantityListProduct(String id){
     ListProduct p=shoppingProducts!.where((element) => element.id==id).first;
    if(p!=null){
      return p.quantity;
    }
    return 1;
   }
   Future<void> updateQuantity( double quantity, String id) async{
      shoppingListRepository.updateQuantity(quantity, id, shoppingList);
      notifyListeners();
   }
}
