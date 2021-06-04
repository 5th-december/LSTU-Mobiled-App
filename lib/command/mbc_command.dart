import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/group.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';

class MbCStartConsumeDialogUpdates {
  Dialog watchedDialog;
  Person readerCompanion;
  MbCStartConsumeDialogUpdates(
      {@required this.watchedDialog, @required this.readerCompanion});
}

class MbCStartConsumeDialogListUpdates {
  Person receiver;
  MbCStartConsumeDialogListUpdates({@required this.receiver});
}

class MbCStartConsumeDiscussionMessages {
  List<Group> groups = [];
  MbCStartConsumeDiscussionMessages({@required this.groups});
}

class MbCStartConsumeDialogMessages {
  final Dialog dialog;
  MbCStartConsumeDialogMessages({@required this.dialog});
}
