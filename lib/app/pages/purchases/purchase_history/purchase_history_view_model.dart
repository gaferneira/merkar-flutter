import 'package:flutter/material.dart';
import '../../../../data/entities/purchase.dart';
import '../../../../data/repositories/purchases_repository.dart';

class PurchaseHistoryViewModel extends ChangeNotifier {
  final PurchasesRepository purchaseHistoryRepository;

  PurchaseHistoryViewModel({required this.purchaseHistoryRepository});

  List<Purchase>? list;
  String? error;

  void loadData() async {
    purchaseHistoryRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
