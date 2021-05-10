import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLocalManager
{
  Future<String> getDefaultSaverDirectory() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  String getFilePath(String basePath, String fileName) => "$basePath/$fileName";

  Future<bool> isFileExists({String basePath, String fileName, String filePath}) async {
    filePath = filePath == null ? filePath : this.getFilePath(basePath, fileName);

    File testingFile = File(filePath);
    return await testingFile.exists();
  }

  Future<int> getFileSize({String basePath, String fileName, String filePath}) async {
    filePath = filePath == null ? filePath : this.getFilePath(basePath, fileName);

    File testingFile = File(filePath);
    return await testingFile.length();
  }
}