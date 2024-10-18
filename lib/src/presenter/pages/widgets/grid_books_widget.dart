import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/presenter/tile/book_tile.dart';
import 'package:flutter/material.dart';

class GridBooksWidget extends StatelessWidget {
  final List<Book> listBooks;
  final bool hasSelectedFavoriteButton;
  const GridBooksWidget(
      {super.key,
      required this.listBooks,
      required this.hasSelectedFavoriteButton});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: listBooks.length,
      itemBuilder: (BuildContext context, int index) {
        return BookTile(
          book: listBooks[index],
          hasSelectedFavoriteButton: hasSelectedFavoriteButton,
        );
      },
    );
  }
}
