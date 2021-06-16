import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/purchases_repository.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';
import 'shopping_list_page.dart';


class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;
  final PurchasesRepository purchasesRepository;

  ShoppingListViewModel(
      {required this.repository, required this.purchasesRepository});

  late ShoppingList shoppingList;
  List<ListProduct>? filterunselectedList;
  List<ListProduct>? filterselectedList;
  List<ListProduct>? unselectedList;
  List<ListProduct>? selectedList;
  String? error;
  bool? ennable;
  File? _listFile;
  final Future<Directory> localPath = getTemporaryDirectory();

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;
    repository.fetchProducts(shoppingList).listen((data) {
      updateList(data);
      filterselectedList = selectedList;
      filterunselectedList = unselectedList;
      error = null;
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void updateList(List<ListProduct> list) {
    unselectedList = <ListProduct>[];
    selectedList = <ListProduct>[];

    list.forEach((product) {
      if (product.selected!) {
        selectedList!.add(product);
      } else {
        unselectedList!.add(product);
      }
    });
   // unselectedList=unselectedList.toList()..sort();
    if(selectedList!.isNotEmpty){
        ennable=true;
      }
    else ennable=false;

    notifyListeners();
  }

  Future<void> selectProduct(int index) async {
    var product = unselectedList![index];
    product.selected = true;
    this.selectedList!.add(product);
    repository.saveProduct(product, shoppingList);
  }

  Future<void> unselectProduct(int index) async {
    var product = selectedList![index];
    product.selected = false;
    this.selectedList!.remove(product);
    repository.saveProduct(product, shoppingList);
  }

  Future<void> updateProduct(ListProduct product, String? oldTotal) async {
    await repository.saveProduct(product, shoppingList);
  }

  String totalPrice() {
    final total = _calculateTotalPrice(unselectedList) +
        _calculateTotalPrice(selectedList);
    return total.toString();
  }

  String totalShopping() => _calculateTotalPrice(selectedList).toString();

  double _calculateTotalPrice(List<ListProduct>? list) {
    if (list != null && list.isNotEmpty) {
      final total = list
          .map((item) => item.quantity * double.parse(item.price))
          .reduce((value, element) => value + element);

      return total;
    }
    return 0;
  }

  Future<void> finishShopping(
      BuildContext context, SingingCharacter option, String detail) async {
    await purchasesRepository.create(detail, selectedList!);
    switch (option) {
      case SingingCharacter.delete:
        repository.remove(shoppingList);
        break;
      case SingingCharacter.reset:
        selectedList!.forEach((product) {
          product.selected = false;
          repository.saveProduct(product, shoppingList);
        });
        break;
      case SingingCharacter.nothing:
        break;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  Future<void> removeProduct(String productId, ShoppingList list)async {
    repository.removeProduct(productId, list);
    notifyListeners();
  }

  Future<void> removeList(ShoppingList shoppingList) async{
    repository.remove(shoppingList);
  }

  Future<File> getListFile() async {
    final directory = localPath;
    final file = await _localFile;
    String content='Producto \b Cantidad\n';
    for(int i=0;i<selectedList!.length;i++) {
      content+='${selectedList![i].name} \b ${selectedList![i].quantity}\n';
    }
    file.writeAsString(content);
    print('File ok ${file.path}');
    Share.shareFiles(['${file.path}']);
    return _listFile=file;

  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${shoppingList.name}.txt');
  }
}
