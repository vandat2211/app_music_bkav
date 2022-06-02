import 'package:app_music_bkav/App.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Search/SearchBloc.dart';
import 'package:app_music_bkav/Search/search_repository.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() => runApp(MultiBlocProvider(
  providers: [
    BlocProvider<BlocMusic>(create: (ctx) => BlocMusic()),
    BlocProvider<TimerCubit>(create: (ctx) => TimerCubit()),
    BlocProvider(create: (ctx)=> SearchBloc(searchRepository: SearchRepositoryImpl(),)),
    BlocProvider(create: (ctx)=> FavoriteBloc()),
  ],
  child: MyApp(),
));
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}
