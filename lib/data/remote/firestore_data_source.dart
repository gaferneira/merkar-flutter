import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDataSource {
  static const COLLECTION_DATA = "data";
  static const TEST_DOC_DATA = "MPHkxVIHqWdkNRs5d95F";

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference getDataDocument() {
    return db.collection(COLLECTION_DATA).doc(_auth.currentUser.uid);
  }
}
