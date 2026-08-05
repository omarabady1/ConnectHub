import 'database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
  }) async {
    if (docId != null) {
      await firestore.collection(path).doc(docId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<void> updateData({
    required String path,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(path).doc(docId).update(data);
  }

  @override
  Future<void> deleteData({required String path, required String docId}) async {
    await firestore.collection(path).doc(docId).delete();
  }

  @override
  Future<bool> checkIfValueExists(
    String collection,
    String field,
    String value,
  ) async {
    final result = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? docId,
    Map<String, dynamic>? query,
  }) async {
    if (docId != null) {
      var data = await firestore.collection(path).doc(docId).get();
      return data.data();
    } else {
      Query<Map<String, dynamic>> data = firestore.collection(path);
      if (query != null) {
        if (query['orderBy'] != null) {
          var orderByField = query['orderBy'];
          var descending = query['descending'];
          data = data.orderBy(orderByField, descending: descending);
        }
        if (query['limit'] != null) {
          var limit = query['limit'];
          data = data.limit(limit);
        }
      }
      var result = await data.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
    Map<String, dynamic>? query,
  }) async {
    Query<Map<String, dynamic>> ref = firestore
        .collection(parentPath)
        .doc(parentDocId)
        .collection(subCollection);

    if (query != null) {
      if (query['orderBy'] != null) {
        final orderByField = query['orderBy'];
        final descending = query['descending'] ?? false;
        ref = ref.orderBy(orderByField, descending: descending);
      }
      if (query['limit'] != null) {
        ref = ref.limit(query['limit']);
      }
    }

    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> addSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
    required Map<String, dynamic> data,
    String? docId,
  }) async {
    final ref = firestore
        .collection(parentPath)
        .doc(parentDocId)
        .collection(subCollection);

    if (docId != null) {
      await ref.doc(docId).set(data);
    } else {
      await ref.add(data);
    }
  }

  @override
  Future<void> deleteSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
  }) async {
    final ref = firestore
        .collection(parentPath)
        .doc(parentDocId)
        .collection(subCollection);

    const batchLimit = 500;

    while (true) {
      final snapshot = await ref.limit(batchLimit).get();
      if (snapshot.docs.isEmpty) return;

      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
