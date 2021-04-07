import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:merkar/data/entities/user_data.dart';
import 'package:merkar/data/remote/firestore_data_source.dart';
import 'package:merkar/data/utils/network/network_info.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  late FirebaseAuth _auth;
  User? _curretUser;

  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  LoginRepositoryImpl(
      {required this.networkInfo, required this.firestoreDataSource}) {
    _auth = FirebaseAuth.instance;
  }

  @override
  User? getCurrentUser() {
    _curretUser = _auth.currentUser;
    return _curretUser;
  }

  @override
  Stream<bool> onLoginStatusChanged() {
    return _auth.authStateChanges().map<bool>((user) => user != null);
  }

  @override
  Future<Either<String, bool>> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(result.user != null);
    } on FirebaseException catch (e) {
      return left(e.message ?? "Firebase exception");
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    _auth.signOut();
    return true;
  }

  @override
  Future<Either<String, bool>> signUp(
      String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user == null) return right(false);

      var userData =
          UserData(userId: result.user!.uid, name: name, email: email);

      await firestoreDataSource.db
          .collection(FirestoreDataSource.COLLECTION_DATA)
          .doc(result.user!.uid)
          .set(userData.toJson());

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<UserData> getUserData() async {
    final ref = await firestoreDataSource.getDataDocument().get();
    return UserData.fromJson(ref.data()!);
  }
}
