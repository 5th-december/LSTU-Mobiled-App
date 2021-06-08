import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/group.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';

class MbCStartConsumeDialogUpdates {
  Dialog watchedDialog;
  Person person;
  MbCStartConsumeDialogUpdates(
      {@required this.watchedDialog, @required this.person});
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
  final Person person;
  MbCStartConsumeDialogMessages({@required this.dialog, @required this.person});
}
