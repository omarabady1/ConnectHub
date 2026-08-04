import 'dart:io';

abstract class CloudStorageService {
  Future<String> uploadFile(File file, String path);
}
