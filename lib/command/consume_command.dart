import 'package:flutter/foundation.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable_week.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/messenger/private_message.dart';

class LoadCurrentUserIdentifier {}

class LoadPersonDetails {
  final Person person;

  LoadPersonDetails(this.person);
}

class LoadProfilePicture {
  final Person person;
  final double size;

  LoadProfilePicture(this.person, this.size);
}

class LoadDisciplineTeacherList {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  LoadDisciplineTeacherList(
      {@required this.discipline,
      @required this.education,
      @required this.semester});
}

class LoadDisciplineDetails {
  final Discipline discipline;
  LoadDisciplineDetails({@required this.discipline});
}

class LoadDisciplineTimetable {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  LoadDisciplineTimetable(
      {@required this.discipline,
      @required this.education,
      @required this.semester});
}

class LoadTeachingMaterialsList {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  LoadTeachingMaterialsList(
      {@required this.discipline,
      @required this.education,
      @required this.semester});
}

class LoadUserEducationListCommand {
  final Person person;

  LoadUserEducationListCommand(this.person);
}

class LoadSemsterListCommand {
  final Education education;

  LoadSemsterListCommand(this.education);
}

class LoadSubjectListCommand {
  final Education education;
  final Semester semester;

  LoadSubjectListCommand(this.education, this.semester);
}

class LoadCurrentEducationsCommand {
  final Person person;

  LoadCurrentEducationsCommand(this.person);
}

class LoadPrivateChatMessagesListCommand {
  final Dialog dialog;
  final int count;
  final String bound;
  LoadPrivateChatMessagesListCommand(
      {@required this.dialog, this.count, this.bound});
}

class LoadDialogListCommand {
  final int count;
  final String bound;
  LoadDialogListCommand({this.count, this.bound});
}

class LoadDisciplineDiscussionListCommand {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  final int count;
  final String bound;
  LoadDisciplineDiscussionListCommand(
      {this.discipline, this.count, this.bound, this.education, this.semester});
}

abstract class MultipartRequestCommand {}

class LoadTeachingMaterialAttachment extends MultipartRequestCommand {
  final String teachingMaterial;
  LoadTeachingMaterialAttachment(this.teachingMaterial);
}

class LoadStudentTaskAnswerMaterialAttachment extends MultipartRequestCommand {
  final WorkAnswerAttachment studentTaskAnswerMaterial;
  LoadStudentTaskAnswerMaterialAttachment(
      {@required this.studentTaskAnswerMaterial});
}

class LoadPrivateMessageMaterialAttachment extends MultipartRequestCommand {
  final PrivateMessage privateMessage;
  LoadPrivateMessageMaterialAttachment({@required this.privateMessage});
}

class LoadDiscussionMessageMaterialAttachment extends MultipartRequestCommand {
  final DiscussionMessage discussionMessage;
  LoadDiscussionMessageMaterialAttachment({@required this.discussionMessage});
}

class UploadPrivateMessageAttachment extends MultipartRequestCommand {
  final PrivateMessage message;
  UploadPrivateMessageAttachment({@required this.message});
}

class UploadDiscussionMessageAttachment extends MultipartRequestCommand {
  final DiscussionMessage message;
  UploadDiscussionMessageAttachment({@required this.message});
}

class UploadWorkAnswerAttachment extends MultipartRequestCommand {
  final WorkAnswerAttachment workAnswerAttachment;
  UploadWorkAnswerAttachment({@required this.workAnswerAttachment});
}

class LoadPersonListByTextQuery {
  final String textQuery;
  final int count;
  final int offset;
  LoadPersonListByTextQuery({this.count, this.offset, this.textQuery});
}

class LoadTimetableCommand {
  final TimetableWeek weekType;
  final Education education;
  final Semester semester;
  LoadTimetableCommand(
      {@required this.weekType,
      @required this.semester,
      @required this.education});
}

class LoadExamsTimetableCommand {
  final Education education;
  final Semester semester;
  LoadExamsTimetableCommand(
      {@required this.education, @required this.semester});
}

class LoadPublicationsListCommand {
  final Person person;
  LoadPublicationsListCommand({@required this.person});
}

class LoadAchievementsListCommand {
  final Person person;
  LoadAchievementsListCommand({@required this.person});
}

class LoadAchievementsSummaryCommand {
  final Person person;
  LoadAchievementsSummaryCommand({@required this.person});
}

class LoadTasksListCommand {
  final Education education;
  final Semester semester;
  final Discipline discipline;
  LoadTasksListCommand(
      {@required this.discipline,
      @required this.education,
      @required this.semester});
}

// Команды старта отслеживания уведолмений из брокера
class StartNotifyOnPerson {
  Person trackedPerson;
  StartNotifyOnPerson({@required this.trackedPerson});
}
