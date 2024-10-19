import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/check_book_downloaded.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_downloaded_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/queue_download_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/snack_bar_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/vocys_epub_controller.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/downloaded_books_notifier.dart';
import 'package:escribo_flutter_anderson/src/presenter/tile/book_tile/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridBooksWidget extends StatelessWidget {
  final List<Book> listBooks;
  final bool hasSelectedFavoriteButton;
  final QueueDownloadComponent queueDownload = QueueDownloadComponent();
  final SnackBarComponent snackBarComponent = SnackBarComponent();

  GridBooksWidget(
      {super.key,
      required this.listBooks,
      required this.hasSelectedFavoriteButton});

  @override
  Widget build(BuildContext context) {
    final CheckBookDownloadedUseCase checkBookDownloadedUseCase =
        Provider.of<CheckBookDownloadedUseCase>(context);
    DownloadedBooksNotifier downloadedBooksNotifier =
        Provider.of<DownloadedBooksNotifier>(context);
    GetDownloadedBooksUseCase getDownloadedBooksUseCase =
        Provider.of<GetDownloadedBooksUseCase>(context);
    final listDownloadedBooks = getDownloadedBooksUseCase.execute();
    downloadedBooksNotifier.loadDownloadedBooks(
        listDownloadedBooks is DataSuccess ? listDownloadedBooks.data! : []);

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount =
          (constraints.maxWidth / 125).floor(); // Número de colunas

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: listBooks.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              final result =
                  await checkBookDownloadedUseCase.execute(listBooks[index]);

              if (!context.mounted) return;

              if (result is DataSuccess) {
                if (result.data!.fileExists) {
                  snackBarComponent.showSnackbar(context, result.data!.message);
                  final VocysEpubController vocysEpubController =
                      VocysEpubController(
                          context: context, epubInfo: result.data!);

                  vocysEpubController.open(
                      result.data!.path, result.data!.lastLocation);
                } else {
                  queueDownload.enqueueDownload(context, listBooks[index]);
                }
              }
            },
            child: BookTile(
              book: listBooks[index],
              hasSelectedFavoriteButton: hasSelectedFavoriteButton,
              downloadedBooksNotifier: downloadedBooksNotifier,
            ),
          );
        },
      );
    });
  }
}
