import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../data/entities/error/failures.dart';
import '../../data/entities/list_product.dart';
import '../../data/entities/purchase.dart';
import '../../data/repositories/purchases_repository.dart';
import '../remote/firestore_data_source.dart';
import '../utils/network/network_info.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  static const COLLECTION_PURCHASES = "purchases";
  static const COLLECTION_PRODUCTS = "products";

  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  PurchasesRepositoryImpl({
    required this.networkInfo,
    required this.firestoreDataSource,
  });

  @override
  Future<Either<Failure, Purchase>> create(
      String detail, List<ListProduct> list) async {
    final today = new DateTime.now();
    final dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final total = list
        .map((item) => item.quantity * double.parse(item.price))
        .reduce((value, element) => value + element);
    final totalProducts = list.length.toString();

    Purchase purchase = Purchase(
        name: detail,
        date: dateSlug,
        total: total.toString(),
        totalProducts: totalProducts);

    WriteBatch batch = firestoreDataSource.db.batch();
    DocumentReference document = firestoreDataSource
        .getDataDocument()
        .collection(COLLECTION_PURCHASES)
        .doc();

    batch.set(document, purchase.toJson());

    list.forEach((product) {
      DocumentReference productDoc =
          document.collection(COLLECTION_PRODUCTS).doc();
      batch.set(productDoc, product.toJson());
    });

    batch.commit();

    return Right(purchase);
  }

  @override
  Stream<List<Purchase>> fetchItems() {
    return firestoreDataSource
        .getDataDocument()
        .collection(COLLECTION_PURCHASES)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
                (documentSnapshot) => Purchase.fromJson(documentSnapshot.data())
                  ..id = documentSnapshot.id
                  ..path = documentSnapshot.reference.path)
            .toList());
  }

  @override
  Future<Either<Failure, bool>> remove(Purchase item) async {
    if (item.id != null) {
      final products = await this
          .firestoreDataSource
          .db
          .doc(item.path)
          .collection(COLLECTION_PURCHASES)
          .get();

      WriteBatch batch = firestoreDataSource.db.batch();
      products.docs.forEach((product) {
        batch.delete(product.reference);
      });
      batch.delete(this.firestoreDataSource.db.doc(item.path));
      batch.commit();

      return Right(true);
    }
    return Right(false);
  }

  @override
  Stream<List<ListProduct>> fetchProducts(Purchase item) {
    return firestoreDataSource.db
        .doc(item.path)
        .collection(COLLECTION_PRODUCTS)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                ListProduct.fromJson(documentSnapshot.data())
                  ..id = documentSnapshot.id
                  ..path = documentSnapshot.reference.path)
            .toList());
  }
}
