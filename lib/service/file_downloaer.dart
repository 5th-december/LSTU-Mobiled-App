import 'dart:io';

import 'package:http/http.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  final AppConfig _config;
  final ApiEndpointConsumer _consumer;

  FileDownloader(this._config, this._consumer);

  Stream<double> progressedDownload(
      String url, String filename, Map<String, String> params,
      {String basePath}) async* {
    if (basePath == null) {
      basePath = (await getApplicationDocumentsDirectory()).path;
    }

    File downloadedFile = File("$basePath/$filename");
    IOSink fileWriteSink = downloadedFile.openWrite();

    ByteStream downloaderStream =
        await this._consumer.consumeResourseAsStream(url, params);

    double totalDownloadedSize = 0;

    await for (final chunk in downloaderStream) {
      fileWriteSink.add(chunk);
      totalDownloadedSize += chunk.length;
      yield totalDownloadedSize;
    }

    downloaderStream.handleError(() {
      fileWriteSink.close();
    });
  }
}
