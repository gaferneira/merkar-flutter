import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:merkar/data/entities/error/failures.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:meta/meta.dart';

import '../entities/shopping_list.dart';
import '../remote/firestore_data_source.dart';
import '../repositories/shopping_lists_repository.dart';
import '../utils/network/network_info.dart';

class ShoppingListsRepositoryImpl implements ShoppingListsRepository {
  static const COLLECTION_SHOPPING_LIST = "shopping_lists";
  static const COLLECTION_PURCHASE_HISTORY = "purchase_history";
  static const COLLECTION_PRODUCTS = "products";

  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  ShoppingListsRepositoryImpl({
    @required this.networkInfo,
    @required this.firestoreDataSource,
  });

  @override
  Future<Either<Failure, ShoppingList>> save(ShoppingList item) async {
    if (item.id != null) {
      await this.firestoreDataSource.db.doc(item.id).set(item.toJson());
    } else {
      final ref = await firestoreDataSource
          .getDataDocument()
          .collection(COLLECTION_SHOPPING_LIST)
          .add(item.toJson());
      item
        ..id = ref.id
        ..path = ref.path;
    }
    return Right(item);
  }

  @override
  Stream<List<ShoppingList>> fetchItems() {
    return firestoreDataSource
        .getDataDocument()
        .collection(COLLECTION_SHOPPING_LIST)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                ShoppingList.fromJson(documentSnapshot.data())
                  ..id = documentSnapshot.id
                  ..path = documentSnapshot.reference.path)
            .toList());
  }

  @override
  Future<Either<Failure, bool>> remove(ShoppingList item) async {
    if (item.id != null) {
      await this.firestoreDataSource.db.doc(item.path).delete();
      return Right(true);
    }
    return Right(false);
  }

  @override
  Stream<List<ListProduct>> fetchProducts(ShoppingList list) {
    return firestoreDataSource.db
        .doc(list.path)
        .collection(COLLECTION_PRODUCTS)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                ListProduct.fromJson(documentSnapshot.data())
                  ..id = documentSnapshot.id
                  ..path = documentSnapshot.reference.path)
            .toList());
  }

  @override
  Future<Either<Failure, bool>> removeProduct(
      String productId, ShoppingList list) async {
    await firestoreDataSource.db
        .doc(list.path)
        .collection(COLLECTION_PRODUCTS)
        .doc(productId)
        .delete();
    return Right(true);
  }

  @override
  Future<Either<Failure, ListProduct>> saveProduct(
      ListProduct product, ShoppingList list) async {
    await firestoreDataSource.db
        .doc(list.path)
        .collection(COLLECTION_PRODUCTS)
        .doc(product.id)
        .set(product.toJson());
    return Right(product);
  }

  @override
  Future<Either<Failure, Purchase>> createPurchaseHistory(
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
        .collection(COLLECTION_PURCHASE_HISTORY)
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
}
