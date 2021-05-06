import 'package:flutter/material.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';

class PurchaseHistoryViewModel extends ChangeNotifier {
  final PurchasesRepository purchaseHistoryRepository;
  List<Purchase>? filterList;
  PurchaseHistoryViewModel({required this.purchaseHistoryRepository});

  List<Purchase>? list;
  String? error;

  void loadData() async {
    purchaseHistoryRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      filterList = list;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
