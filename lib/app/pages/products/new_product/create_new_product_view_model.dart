import 'package:flutter/material.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/repositories/products_repository.dart';

class CreateNewProductsViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  CreateNewProductsViewModel({required this.productsRepository});

  String? error;

  void saveProduct(Product product, BuildContext context) async {
    final result = await productsRepository.save(product);
  }
}
