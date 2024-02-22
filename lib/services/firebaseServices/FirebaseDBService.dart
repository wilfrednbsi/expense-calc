import 'package:cloud_firestore/cloud_firestore.dart';

const String mainDoc = 'ExpenseCalculator';
abstract class FirebaseDB {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String collectionPath;
  final String mainPath;

  FirebaseDB(this.mainPath,this.collectionPath);

  CollectionReference get collection => _fireStore.collection(mainPath).doc(mainDoc).collection(collectionPath);

  Future<DocumentReference> add(Map<String, dynamic> data) async {
    return await collection.add(data);
  }

  Future<String> setDoc(String id, Map<String, dynamic> data) async {
    await collection.doc(id).set(data);
    return id;
  }

  Future<void> update(String documentId, Map<String, dynamic> data) async {
    await collection.doc(documentId).update(data);
  }

  Future<DocumentSnapshot<Object?>> getDoc(String documentId) async {
   return await collection.doc(documentId).get();
  }


  Future<QuerySnapshot> checkIfDocExist( String key,var data,) async {
    return await collection.where(key, isEqualTo: data).limit(1).get();
  }



  Future<void> delete(String documentId) async {
    await collection.doc(documentId).delete();
  }

  Stream<List<Map<String, dynamic>>> get documents {
    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => {'docId': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList());
  }

  Future<QuerySnapshot<Object?>> documentsWithOrderWhere({
    required String compareField,required compareValue,
    required String sortField, bool descending = false
  }) {
    return collection
        .where(compareField,isEqualTo: compareValue)
        // .orderBy(sortField,descending: descending)
        .get();
  }
}

class FirebaseDBService extends FirebaseDB{
  FirebaseDBService(super.mainPath, super.collectionPath);
}
