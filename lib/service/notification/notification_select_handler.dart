import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';

abstract class NotificationSelectHandler {
  final NotificationSelectHandler next;
  NotificationSelectHandler({this.next});

  @protected
  bool isApplicable(Map<String, dynamic> data);

  @protected
  void handle(Map<String, dynamic> data);

  void handleApply(Map<String, dynamic> notificationData) {
    bool applicable = this.isApplicable(notificationData);

    if (applicable) {
      this.handle(notificationData);
    } else if (this.next != null) {
      this.next.handleApply(notificationData);
    }
  }
}

class HandleFileDownloadNotification extends NotificationSelectHandler {
  HandleFileDownloadNotification({NotificationSelectHandler next})
      : super(next: next);
  @override
  bool isApplicable(Map<String, dynamic> data) {
    return data.containsKey('type') && data['type'] == 'file-download';
  }

  @override
  void handle(Map<String, dynamic> data) {
    if (!data.containsKey('filename') || data['filename'] == '') return;

    OpenFile.open(data['filename']);
  }
}
