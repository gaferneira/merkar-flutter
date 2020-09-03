import 'package:merkar/data/entities/product.dart';
import 'package:meta/meta.dart';

import '../remote/firestore_data_source.dart';
import '../repositories/products_repository.dart';
import '../utils/network/network_info.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  ProductsRepositoryImpl({
    @required this.networkInfo,
    @required this.firestoreDataSource,
  });

  @override
  Stream<List<Product>> fetchByList(String listId) {
    return firestoreDataSource.db
        .doc(listId)
        .collection('products')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
                (documentSnapshot) => Product.fromJson(documentSnapshot.data()))
            .toList());
  }
}
