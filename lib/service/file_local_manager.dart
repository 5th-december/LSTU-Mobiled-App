import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileLocalManager {
  Future<String> getDefaultSaverDirectory() async {
    return (await getDownloadsDirectory()).path;
  }

  Future<void> deleteFile(String filePath) async {
    File file = File(filePath);
    await file.delete();
  }

  String getFilePath(String basePath, String fileName) => "$basePath/$fileName";

  String getFileName(String filePath) => filePath.split('/')?.last;

  String getFileBase(String filePath) => filePath.substring(0, filePath.lastIndexOf('/'));

  Future<bool> isFileExists(
      {String basePath, String fileName, String filePath}) async {
    filePath =
        filePath != null ? filePath : this.getFilePath(basePath, fileName);

    return await FileSystemEntity.type(filePath) != FileSystemEntityType.notFound;
  }

  Future<int> getSize(String filePath) async {
    File testingFile = File(filePath);
    return await testingFile.length();
  }

  Future<Map<String, bool>> getPremissions(String path) async {
    FileSystemEntityType actualType = await FileSystemEntity.type(path);
    if(actualType == FileSystemEntityType.directory) {
      Directory dir = Directory(path);
      await dir.stat();
    } else if (actualType == FileSystemEntityType.file) {
      File file = File(path);
      await file.stat();
    }
    return {'r': true,  'w': true};
  }

}
