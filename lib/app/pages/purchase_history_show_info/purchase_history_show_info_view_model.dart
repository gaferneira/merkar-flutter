import 'package:flutter/material.dart';
import 'package:merkar/app/pages/purchase_history_show_info/purchase_history_show_info_page.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';

class PurchaseHistoryShowInfoViewModel extends ChangeNotifier {
  final PurchasesRepository PurchaseHistoryRepository;

  PurchaseHistoryShowInfoViewModel({@required this.PurchaseHistoryRepository});

  List<ListProduct> listProducts;
  String error;

  void getProducts(Purchase listPurchase) async {
    PurchaseHistoryRepository.fetchProducts(listPurchase).listen((data) {
      listProducts = data;
      // print(listProducts);
      // print(listProducts.length);
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
