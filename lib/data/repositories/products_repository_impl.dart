import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/entities/error/failures.dart';
import '../entities/product.dart';
import '../remote/firestore_data_source.dart';
import '../repositories/products_repository.dart';
import '../utils/network/network_info.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  static const COLLECTION_DEFAULT_PRODUCTS = "products";

  static const COLLECTION_PRODUCTS = "products";

  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  ProductsRepositoryImpl({
    @required this.networkInfo,
    @required this.firestoreDataSource,
  });

  @override
  Stream<List<Product>> fetchDefaultProducts() {
    return getDefaultCollection()
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Product.fromJson(documentSnapshot.data())
              ..id = documentSnapshot.id
              ..path = documentSnapshot.reference.path)
            .toList());
  }

  @override
  Stream<List<Product>> fetchItems() {
    return firestoreDataSource
        .getDataDocument()
        .collection(COLLECTION_PRODUCTS)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => Product.fromJson(documentSnapshot.data())
              ..path = documentSnapshot.reference.path
              ..id = documentSnapshot.id)
            .toList());
  }

  @override
  Future<Either<Failure, Product>> save(Product item) async {
    if (item.id != null) {
      await this.firestoreDataSource.db.doc(item.id).set(item.toJson());
    } else {
      final ref = await firestoreDataSource
          .getDataDocument()
          .collection(COLLECTION_PRODUCTS)
          .add(item.toJson());
      item.path = ref.path;
      item.id = ref.id;
    }
    return Right(item);
  }

  @override
  Future<Either<Failure, bool>> remove(Product item) async {
    if (item.id != null) {
      await this.firestoreDataSource.db.doc(item.path).delete();
      return Right(true);
    }
    return Right(false);
  }

  CollectionReference getDefaultCollection() {
    return firestoreDataSource.db.collection(COLLECTION_DEFAULT_PRODUCTS);
  }
}
