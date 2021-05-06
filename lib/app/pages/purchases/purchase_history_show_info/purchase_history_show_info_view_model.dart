import 'package:flutter/material.dart';

import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';

class PurchaseHistoryShowInfoViewModel extends ChangeNotifier {
  final PurchasesRepository purchaseHistoryRepository;

  PurchaseHistoryShowInfoViewModel({required this.purchaseHistoryRepository});

  List<ListProduct>? listProducts;
  String? error;

  void getProducts(Purchase listPurchase) async {
    purchaseHistoryRepository.fetchProducts(listPurchase).listen((data) {
      listProducts = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
