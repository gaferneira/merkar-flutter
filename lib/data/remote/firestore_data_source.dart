import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSource {
  static const COLLECTION_DATA = "data";
  static const TEST_DOC_DATA = "MPHkxVIHqWdkNRs5d95F";

  FirebaseFirestore db = FirebaseFirestore.instance;

  DocumentReference getDataDocument() {
    return db.collection(COLLECTION_DATA).doc(TEST_DOC_DATA);
  }
}
