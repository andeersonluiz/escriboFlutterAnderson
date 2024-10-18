import 'package:escribo_flutter_anderson/injection.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_favorite_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/pages/home_page.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_bloc.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/selected_button_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderInjection(
        child: MultiProvider(
      providers: [
        Provider<BooksBloc>(
            create: (context) => BooksBloc(context.read<GetBooksUseCase>(),
                context.read<GetFavoritesBooksUseCase>())),
        Provider<SelectedButtonNotifier>(
          create: (context) => SelectedButtonNotifier(),
        ),
      ],
      child: MaterialApp(
          title: 'Escribo Ebooks',
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff01579B),
            ),
            useMaterial3: true,
          ),
          home: const SafeArea(child: HomePage())),
    ));
  }
}
