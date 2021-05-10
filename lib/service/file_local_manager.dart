import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLocalManager {
  Future<String> getDefaultSaverDirectory() async {
    return (await getDownloadsDirectory()).path;
  }

  String getFilePath(String basePath, String fileName) => "$basePath/$fileName";

  String getFileName(String filePath) => filePath.split('/')?.last;

  Future<bool> isFileExists(
      {String basePath, String fileName, String filePath}) async {
    filePath =
        filePath != null ? filePath : this.getFilePath(basePath, fileName);

    return await FileSystemEntity.type(filePath) != FileSystemEntityType.notFound;
  }

  Future<int> getFileSize(
      {String basePath, String fileName, String filePath}) async {
    filePath =
        filePath != null ? filePath : this.getFilePath(basePath, fileName);

    File testingFile = File(filePath);
    return await testingFile.length();
  }

}
