class LocalFilesystemObject {
  String _filePath;

  String get filePath => this._filePath;
  String get fileExtension => '';

  LocalFilesystemObject.fromFilePath(this._filePath);
  LocalFilesystemObject.fromNameAndBase(String basePath, String fileName) {
    this._filePath = "$basePath/$fileName";
  }
}
