abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
  });

  Future<bool> checkIfValueExists(
    String collection,
    String field,
    String value,
  );

  Future<dynamic> getData({required String path, String? docId, Map<String, dynamic>? query});
}
