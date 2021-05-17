import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:merkar/data/entities/user_data.dart';
import 'package:merkar/data/remote/firestore_data_source.dart';
import 'package:merkar/data/utils/network/network_info.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final NetworkInfo networkInfo;
  final FirestoreDataSource firestoreDataSource;

  User? _curretUser;

  LoginRepositoryImpl(
      {required this.networkInfo, required this.firestoreDataSource});

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

  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }
}
