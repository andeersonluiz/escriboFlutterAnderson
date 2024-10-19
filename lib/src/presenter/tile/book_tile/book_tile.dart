import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/favorite_controller_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/download_notifier.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/downloaded_books_notifier.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/favorite_button_notifier.dart';
import 'package:escribo_flutter_anderson/src/presenter/tile/book_tile/widgets/container_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final bool hasSelectedFavoriteButton;
  final DownloadedBooksNotifier downloadedBooksNotifier;
  final FavoriteButtonNotifier favoriteButtonNotifier =
      FavoriteButtonNotifier();
  final DownloadNotifier downloadNotifier = DownloadNotifier();

  BookTile(
      {super.key,
      required this.book,
      required this.hasSelectedFavoriteButton,
      required this.downloadedBooksNotifier});

  @override
  Widget build(BuildContext context) {
    favoriteButtonNotifier.updateFavorite(book.isFavorite);
    downloadNotifier.setIsDownloaded(book.isDownloaded);

    return Column(
      children: [
        Expanded(
            flex: 8,
            child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    buildBookCoverImage(),
                    buildFavoriteButton(),
                    buildDownloadInfo()
                  ],
                ))),
        Expanded(
            flex: 2,
            child: Center(
                child: Text(
              book.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            )))
      ],
    );
  }

  Widget buildBookCoverImage() {
    return Positioned.fill(
        child: ValueListenableBuilder(
            valueListenable: downloadedBooksNotifier.downloadedBooks,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Opacity(
                opacity: value.contains(book) ? 1 : 0.5,
                child: Image.network(
                  book.coverUrl,
                  fit: BoxFit.fill,
                ),
              );
            }));
  }

  Widget buildFavoriteButton() {
    return FavoriteControllerComponent(
        book: book,
        favoriteButtonNotifier: favoriteButtonNotifier,
        hasSelectedFavoriteButton: hasSelectedFavoriteButton,
        child: Stack(
          children: [
            const Positioned(
              right: 0,
              top: 0,
              child: Icon(
                FontAwesomeIcons.solidBookmark,
                size: 38,
                color: Colors.white,
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: favoriteButtonNotifier.state,
                builder: (BuildContext context, dynamic value, _) {
                  return Positioned(
                    right: 3,
                    top: 0,
                    child: value
                        ? const Icon(
                            FontAwesomeIcons.solidBookmark,
                            size: 32,
                            color: Colors.red, //O orignal era azul
                          )
                        : const Icon(
                            FontAwesomeIcons.bookmark,
                            size: 32,
                            color: Colors.red, //O orignal era azul
                          ),
                  );
                }),
          ],
        ));
  }

  Widget buildDownloadInfo() {
    return ValueListenableBuilder<List<Book>>(
        valueListenable: downloadedBooksNotifier.queueBooks,
        builder: (BuildContext context, List<Book> queueBooks, Widget? child) {
          if (queueBooks.contains(book)) {
            return const ContainerInfoWidget(text: 'Na Fila');
          }
          return ValueListenableBuilder<Book?>(
              valueListenable: downloadedBooksNotifier.bookDownloading,
              builder:
                  (BuildContext context, Book? bookDownloading, Widget? child) {
                if (bookDownloading != null && bookDownloading.id == book.id) {
                  return const ContainerInfoWidget(text: 'Baixando');
                } else {
                  return Container();
                }
              });
        });
  }
}
