import 'dart:io';

import 'package:hive/hive.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  HiveService() {
    Future.delayed(Duration.zero, () async {
      Directory storageDirectory = await getApplicationDocumentsDirectory();
      Hive.init(storageDirectory.path);
    });
  }

  void initializeTypeGenerators() {
    Hive.registerAdapter(PrivateMessageAdapter());
    Hive.registerAdapter(PersonAdapter());
    Hive.registerAdapter(DialogAdapter());
  }
}
