import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:lk_client/service/config/app_config.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/http_service.dart';

abstract class FileOperationStatus {
  final String filePath;
  FileOperationStatus(this.filePath);
}

class FileOperationProgress extends FileOperationStatus {
  final double rate;
  FileOperationProgress(String filePath, this.rate) : super(filePath);
}

class FileOperationDone extends FileOperationStatus {
  FileOperationDone(String filePath) : super(filePath);
}

class FileOperationError extends FileOperationStatus {
  FileOperationError(String filePath) : super(filePath);
}

class FileTransferManager {
  final AppConfig _config;
  final ApiEndpointConsumer _endpointConsumer;
  final FileLocalManager _fileLocalManager;

  FileTransferManager(
      this._config, this._endpointConsumer, this._fileLocalManager);

  Stream<FileOperationStatus> progressedDownload(String url,
      Map<String, String> params, String apiToken, String filePath) async* {
    StreamController<FileOperationStatus> notifier =
        StreamController<FileOperationStatus>();

    File downloadedFile = File(filePath);
    IOSink fileWriteSink = downloadedFile.openWrite();

    ByteStream downloaderStream = await this
        ._endpointConsumer
        .consumeResourseAsStream(url, params, apiJwtToken: apiToken);

    double totalDownloadedSize = 0;

    downloaderStream.listen((chunk) {
      fileWriteSink.add(chunk);
      totalDownloadedSize += chunk.length;
      notifier.sink.add(FileOperationProgress(filePath, totalDownloadedSize));
    }, onError: (error) async {
      fileWriteSink.close();
      await downloadedFile.delete();
      notifier.sink.add(FileOperationError(filePath));
    }, onDone: () async {
      await fileWriteSink.close();
      notifier.sink.add(FileOperationDone(filePath));
      notifier.close();
    });

    yield* notifier.stream;
  }

  Stream<FileOperationStatus> progressedUpload(String url,
      Map<String, String> params, String apiToken, String filePath) async* {
    StreamController<FileOperationStatus> notifier =
        StreamController<FileOperationStatus>();

    File uploadingFile = File(filePath);
    int fileSize = await uploadingFile.length();
    Stream<List<int>> fileReadingSink = uploadingFile.openRead();
    String fileName = this._fileLocalManager.getFileName(filePath);

    double totalUploadedSize = 0;

    StreamController<List<int>> sc = StreamController<List<int>>();
    Stream<List<int>> producer = sc.stream;

    fileReadingSink.listen((event) {
      sc.sink.add(event);
      totalUploadedSize += event.length;
      notifier.sink.add(FileOperationProgress(filePath, totalUploadedSize));
    }, onError: (error) {
      sc.close();
      notifier.sink.add(FileOperationError(filePath));
    }, onDone: () {
      sc.close();
      notifier.sink.add(FileOperationDone(filePath));
      notifier.close();
    });

    this._endpointConsumer.produceResourseAsStream(
        url, params, 1, ['attachment'], [fileName], [producer], [fileSize],
        apiJwtToken: apiToken);

    yield* notifier.stream;
  }
}
