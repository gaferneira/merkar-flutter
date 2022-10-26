import 'package:flutter/material.dart';
import '../../../../data/entities/purchase.dart';
import '../../../../data/repositories/purchases_repository.dart';

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
  void delete(Purchase list){
    purchaseHistoryRepository.remove(list);
  }
}
