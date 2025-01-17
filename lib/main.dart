import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_now/trending/screen/trending.dart';
import '../trending/bloc/trending_bloc.dart';
import 'data/fetch_movies.dart';
import 'db/database.dart';
import 'trending/screen/trending.dart';


final dbHelper = DatabaseHelper();
Future<void> main() async{
  final fetchMovies = FetchMovies();
  WidgetsFlutterBinding.ensureInitialized();

  await dbHelper.init();

  runApp(
    RepositoryProvider.value(
      value: fetchMovies, 
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fetchMovies = FetchMovies();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TrendingBloc(fetchMovies),
        ),
      ],
      child: MaterialApp(
        title: 'Movie Now',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TrendingScreen(),
      ),
    );
  }
}
