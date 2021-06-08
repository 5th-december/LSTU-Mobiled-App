import 'package:flutter/foundation.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/messenger/dialog.dart';

abstract class UserProduceCommand {}

class UpdateProfileInformation {}

class SendNewPrivateMessage {
  final Dialog dialog;
  SendNewPrivateMessage({@required this.dialog});
}

class SendNewDiscussionMessage {
  final Education education;
  final Discipline discipline;
  final Semester semester;
  SendNewDiscussionMessage(
      {@required this.education,
      @required this.discipline,
      @required this.semester});
}

class SendWorkAnswerAttachment {
  final StudentWork studentWork;
  final Education education;
  SendWorkAnswerAttachment(
      {@required this.studentWork, @required this.education});
}
