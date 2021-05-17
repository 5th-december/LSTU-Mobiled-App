class LocalFilesystemObject {
  String _filePath;

  LocalFilesystemObject.fromFilePath(this._filePath);
  LocalFilesystemObject.fromNameAndBase(String basePath, String fileName) {
    this._filePath = "$basePath/$fileName";
  }

  String get filePath => this._filePath;
}