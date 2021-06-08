import 'package:flutter/foundation.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/service/notification/notifier.dart';

abstract class NotificationProducer {
  static int _identifierNumber = 0;
  static int getUniqueNumber() => _identifierNumber++;

  final Notifier notifier;
  int _notificationId;
  NotificationProducer({@required this.notifier}) {
    this._notificationId = NotificationProducer.getUniqueNumber();
  }

  Future<void> notify();
}

class FileDownloadNotificationProducer extends NotificationProducer {
  LocalFilesystemObject file;
  bool downloadedSuccess;

  FileDownloadNotificationProducer(
      {@required this.file,
      @required this.downloadedSuccess,
      @required Notifier notifier})
      : super(notifier: notifier);

  Future<void> notify() async {
    String title = this.downloadedSuccess ? 'Загружен файл' : 'Ошибка загрузки';
    String body = this.file.filePath;
    Map<String, dynamic> payload = {
      'type': 'file-download',
      'filename': this.file.filePath
    };

    this.notifier.showNotification(this._notificationId, title, body, payload);
  }

  Future<void> cancel() async {
    this.notifier.cancelNotification(this._notificationId);
  }
}
