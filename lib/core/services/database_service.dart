abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
  });

  Future<void> updateData({
    required String path,
    required String docId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({required String path, required String docId});

  Future<bool> checkIfValueExists(
    String collection,
    String field,
    String value,
  );

  Future<dynamic> getData({
    required String path,
    String? docId,
    Map<String, dynamic>? query,
  });

  Future<List<Map<String, dynamic>>> getSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
    Map<String, dynamic>? query,
  });

  Future<void> addSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
    required Map<String, dynamic> data,
    String? docId,
  });

  Future<void> deleteSubCollectionData({
    required String parentPath,
    required String parentDocId,
    required String subCollection,
  });
}
