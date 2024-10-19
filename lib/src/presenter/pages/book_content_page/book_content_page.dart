import 'package:escribo_flutter_anderson/src/domain/usecases/check_book_downloaded.dart';
import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookContentPage extends StatefulWidget {
  final String pathBook;

  const BookContentPage({super.key, required this.pathBook});

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  late final CheckBookDownloadedUseCase checkBookDownloadedUseCase;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    VocsyEpub.open(widget.pathBook);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EPUB Viewer'),
      ),
      body: const Center(
        child:
            CircularProgressIndicator(), // Indicador de progresso enquanto o EPUB é aberto
      ),
    );
  }
}


/*FutureBuilder(
      future: checkBookDownloadedUseCase.execute(widget.book),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final DataState<DownloadInfo> result = snapshot.data;
          if (result is DataSuccess) {
            return Text(result.data!.path);
          } else {
            return Container();
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );*/