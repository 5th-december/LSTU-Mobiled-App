import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/notification/notifier.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';
import 'package:lk_client/widget/chunk/link_open_widget.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class TeachMaterialsList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;

  TeachMaterialsList(
      {Key key,
      @required this.education,
      @required this.semester,
      @required this.discipline})
      : super(key: key);

  @override
  _TeachMaterialsListState createState() => _TeachMaterialsListState();
}

class _TeachMaterialsListState extends State<TeachMaterialsList> {
  TeachingMaterialListLoadingBloc _loadingBloc;
  FileLocalManager _fileLocalManager;
  Notifier _appNotifier;
  FileTransferService _fileTransferService;
  FileDownloaderBlocProvider _fileDownloaderBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider serviceProvider =
        AppStateContainer.of(context).serviceProvider;
    if (this._loadingBloc == null) {
      DisciplineQueryService queryService =
          serviceProvider.disciplineQueryService;
      this._loadingBloc = TeachingMaterialListLoadingBloc(queryService);
    }

    if (this._fileLocalManager == null) {
      this._fileLocalManager = serviceProvider.fileLocalManager;
    }

    if (this._appNotifier == null) {
      this._appNotifier = serviceProvider.notifier;
    }

    if (this._fileTransferService == null) {
      this._fileTransferService = serviceProvider.fileTransferService;
    }

    if (this._fileDownloaderBlocProvider == null) {
      this._fileDownloaderBlocProvider =
          LoaderProvider.of(context).fileDownloaderBlocProvider;
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._loadingBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._loadingBloc.eventController.sink.add(
        StartConsumeEvent<LoadTeachingMaterialsList>(
            request: LoadTeachingMaterialsList(
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester)));

    return StreamLoadingWidget<List<TeachingMaterial>>(
      loadingStream: this._loadingBloc.consumingStateStream,
      childBuilder: (List<TeachingMaterial> teachingMaterials) {
        return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 8.0,
                ),
            itemCount: teachingMaterials.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                teachingMaterials[index].materialType ??
                                    'Материал дисциплины',
                                style: Theme.of(context).textTheme.subtitle2))
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                teachingMaterials[index].materialName ??
                                    'Прикрепленный материал',
                                style: Theme.of(context).textTheme.headline4))
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          () {
                            if (teachingMaterials[index].attachment != null) {
                              String fileExtension = teachingMaterials[index]
                                      .attachment
                                      .attachmentName
                                      .split('.')
                                      ?.last ??
                                  '';
                              double fileSize = double.parse(
                                  teachingMaterials[index]
                                      .attachment
                                      .attachmentSize);
                              String sizeTitle = fileSize > 1024
                                  ? (fileSize / 1024).toStringAsFixed(2) +
                                      ' Мб.'
                                  : fileSize.toStringAsFixed(2) + ' Кб.';
                              String teachingMaterialInfo =
                                  "Файл $fileExtension, $sizeTitle";

                              return FileDownloadWidget(
                                fileMaterial: DownloadFileMaterial(
                                  originalFileName: teachingMaterials[index]
                                      .attachment
                                      .attachmentName,
                                  attachmentId: teachingMaterials[index].id,
                                  attachment:
                                      teachingMaterials[index].attachment,
                                  command: LoadTeachingMaterialAttachment(
                                      teachingMaterials[index].id),
                                ),
                                proxyBloc: TeachingMaterialsDownloaderProxyBloc(
                                    fileDownloaderBlocProvider:
                                        this._fileDownloaderBlocProvider,
                                    fileLocalManager: this._fileLocalManager,
                                    fileTransferService:
                                        this._fileTransferService,
                                    appNotifier: this._appNotifier),
                              );
                            } else if (teachingMaterials[index].externalLink !=
                                null) {
                              return LinkOpenWidget(
                                externalLink: DownloadExternalLinkMaterial(
                                    externalLink: ExternalLink(
                                        linkContent: teachingMaterials[index]
                                            .externalLink
                                            .linkContent,
                                        linkText: teachingMaterials[index]
                                            .externalLink
                                            .linkText)),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }()
                        ])
                  ]));
            });
      },
    );
  }
}
