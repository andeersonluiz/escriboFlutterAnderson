import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/data/models/epub_info_model.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final NotificationDetails platformChannelSpecifics;
  late final String basePath;
  final StreamController<int> _downloadProgressController =
      StreamController<int>.broadcast();

  Stream<int> get downloadProgressStream => _downloadProgressController.stream;

  DownloadService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Channel for download notifications',
      priority: Priority.high,
      showWhen: true,
      onlyAlertOnce: true,
      silent: true,
    );

    platformChannelSpecifics =
        const NotificationDetails(android: androidPlatformChannelSpecifics);
    basePath = (await getExternalStorageDirectory())!.path;
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showDownloadNotification(
      int progress, int idBook, String fileName) async {
    await flutterLocalNotificationsPlugin.show(
      idBook * -1,
      'Baixando arquivo  $fileName',
      'Progresso do download: $progress%',
      platformChannelSpecifics,
    );
  }

  Future<void> _updateDownloadNotification(
      int progress, int idBook, String fileName) async {
    await flutterLocalNotificationsPlugin.show(
      idBook * -1,
      'Baixando arquivo $fileName',
      'Progresso do download: $progress%',
      platformChannelSpecifics,
    );
  }

  Future<void> _showDownloadCompletedNotification(
      int idBook, String fileName) async {
    await flutterLocalNotificationsPlugin.cancel(idBook * -1);
    await flutterLocalNotificationsPlugin.cancel(idBook);

    await flutterLocalNotificationsPlugin.show(
      idBook,
      'Download Completo',
      '$fileName foi baixado com sucesso!!',
      platformChannelSpecifics,
    );
  }

  Future<void> _showErrorDownloadNotification(
      int idBook, String fileName) async {
    await flutterLocalNotificationsPlugin.cancel(idBook * -1);
    await flutterLocalNotificationsPlugin.cancel(idBook);

    await flutterLocalNotificationsPlugin.show(
      idBook,
      'Erro ao baixar $fileName',
      'Ocorreu um erro ao fazer o download, verifique sua conexão.',
      platformChannelSpecifics,
    );
  }

  Future<void> downloadBook(BookModel book) async {
    try {
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(minutes: 10),
      ));
      final bookFormated = book.copyWith(
          title: book.title.replaceAll(':', '_').replaceAll(' ', '_'));
      String fileName = "${bookFormated.title}.epub";
      String filePath = "$basePath/Escribo Ebook/$fileName";

      await _showDownloadNotification(
        0,
        book.id,
        fileName,
      );

      await dio.download(book.downloadUrl, filePath,
          onReceiveProgress: (received, total) async {
        if (total != -1) {
          double progress = (received / total) * 100;
          _downloadProgressController.add(progress.toInt());
          await _updateDownloadNotification(
              progress.toInt(), book.id, fileName);
        }
      }).then((_) async {
        await _showDownloadCompletedNotification(book.id, fileName);
        _downloadProgressController.add(101);

        Left("Abrindo ${book.title}...");
      }, onError: (_) async {
        _downloadProgressController.add(-1);
        await _showErrorDownloadNotification(book.id, fileName);
      });
    } catch (e) {
      _downloadProgressController.add(-1);
    }
  }

  Future<Either<EpubInfoModel, ErrorInfo>> checkBookDownloaded(
      BookModel book) async {
    try {
      final bookFormated = book.copyWith(
          title: book.title.replaceAll(':', '_').replaceAll(' ', '_'));
      String fileName = "${bookFormated.title}.epub";
      String filePath = "$basePath/Escribo Ebook/$fileName";

      if ((await File(filePath).exists())) {
        return Left(EpubInfoModel(
          bookId: book.id,
          fileExists: true,
          message: "Abrindo ${book.title}",
          path: filePath,
        ));
      }
      return Left(EpubInfoModel(
        bookId: book.id,
        fileExists: false,
        message:
            "Baixando ${book.title}, aguarde o download ser concluido para abrir.",
      ));
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.unknownError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }
}
