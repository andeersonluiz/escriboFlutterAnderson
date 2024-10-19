import 'dart:async';
import 'dart:collection';
import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/download_book_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/snack_bar_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/snack_bar_stream_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/downloaded_books_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QueueDownloadComponent {
  final Queue<Book> _downloadQueue = Queue();
  bool _isDownloading = false;
  final SnackBarComponent snackBarComponent = SnackBarComponent();
  final SnackBarStreamComponent snackBarStreamComponent =
      SnackBarStreamComponent();

  void _startNextDownload(BuildContext context) async {
    DownloadBookUseCase downloadBookUseCase = context.read();
    DownloadedBooksNotifier downloadedBooksNotifier = context.read();

    if (_downloadQueue.isNotEmpty && !_isDownloading) {
      final book = _downloadQueue.removeFirst();
      downloadedBooksNotifier.removeBookQueue(book);
      downloadedBooksNotifier.setBookDownloading(book);

      _isDownloading = true;

      final resultDownload = downloadBookUseCase.execute(book);

      bool firstExecution = true;
      StreamSubscription<DataState<String>>? subscription;
      subscription = resultDownload.listen(
        (data) async {
          if (!context.mounted) return;
          if (firstExecution) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarStreamComponent.build(context));
            firstExecution = false;
          }
          if (data is DataStream) {
            snackBarStreamComponent.updateString(
              data.data!,
            );
          } else if (data is DataSuccess) {
            snackBarStreamComponent.hideSnackBar(context);

            snackBarComponent.showSnackbarWithCloseAction(context, data.data!,
                () => downloadedBooksNotifier.addDownloadedBooks(book));
            await Future.delayed(const Duration(seconds: 2), () {});

            _isDownloading = false;
            if (!context.mounted) return;
            _startNextDownload(context);
            subscription?.cancel();
          } else {
            snackBarStreamComponent.hideSnackBar(context);

            snackBarComponent.showSnackbar(context, data.error!.message);

            await Future.delayed(const Duration(seconds: 2));

            _isDownloading = false;

            if (!context.mounted) return;
            _startNextDownload(context);
            subscription?.cancel();
          }
        },
      );
    } else {
      downloadedBooksNotifier.setBookDownloading(null);
    }
  }

  void enqueueDownload(BuildContext context, Book book) {
    DownloadedBooksNotifier downloadedBooksNotifier = context.read();

    _downloadQueue.addLast(book);
    downloadedBooksNotifier.addBookQueue(book);

    if (!_isDownloading) {
      _startNextDownload(context);
    }
  }
}
