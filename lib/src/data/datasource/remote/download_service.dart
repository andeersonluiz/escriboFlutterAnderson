import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/path_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DownloadService {
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final NotificationDetails platformChannelSpecifics;
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
    );

    platformChannelSpecifics =
        const NotificationDetails(android: androidPlatformChannelSpecifics);

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

  Future<Either<String, ErrorInfo>> downloadBook(BookModel book) async {
    try {
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(minutes: 10),
      ));
      final bookFormated = book.copyWith(
          title: book.title
              .replaceAll(':', '_') // Substitui os dois pontos por sublinhados
              .replaceAll(' ', '_'));
      const path = PathConstants.pathDownloadAndroid;
      String fileName = "${bookFormated.title}.epub";

      int counter = 1;
      String filePath = "$path/$fileName";

      while (await File(filePath).exists()) {
        fileName = "${bookFormated.title} ($counter).epub";
        filePath = "$path/$fileName";
        counter++;
      }

      await _showDownloadNotification(
        0,
        book.id,
        fileName,
      );
      bool hasError = false;
      await dio.download(book.downloadUrl, filePath,
          onReceiveProgress: (received, total) async {
        if (total != -1) {
          double progress = (received / total) * 100;
          await _updateDownloadNotification(
              progress.toInt(), book.id, fileName);
        }
      }).then((_) async {
        await _showDownloadCompletedNotification(book.id, fileName);
      }, onError: (_) async {
        await _showErrorDownloadNotification(book.id, fileName);
        hasError = true;
      });

      if (hasError) {
        return Right(ErrorInfo(message: Strings.noConnection));
      }
      return const Left(
          "${Strings.downloadSuccess} ${PathConstants.pathDownloadAndroid}");
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.unknownError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }
}
