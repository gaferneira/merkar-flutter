import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../entities/error/failures.dart';
import '../entities/shopping_list.dart';
import '../local/local_data_source.dart';
import '../remote/firestore_data_source.dart';
import '../repositories/shopping_lists_repository.dart';
import '../utils/network/network_info.dart';

class ShoppingListsRepositoryImpl implements ShoppingListsRepository {
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  ShoppingListsRepositoryImpl({
    @required this.localDataSource,
    @required this.networkInfo,
    @required this.firestoreDataSource,
  });

  @override
  Stream<List<ShoppingList>> fetchLists() {
    return firestoreDataSource.db
        .collection('data')
        .doc("MPHkxVIHqWdkNRs5d95F")
        .collection('shopping_lists')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) =>
                ShoppingList.fromJson(documentSnapshot.data()))
            .toList());
  }

  Future<Either<Failure, List<ShoppingList>>> getList() async {
    final categories = await localDataSource.getAllCategories();
    await Future.delayed(Duration(milliseconds: 3000));
    return Right(categories);
  }
}
