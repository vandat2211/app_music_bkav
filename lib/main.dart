import 'package:app_music_bkav/App.dart';
import 'package:app_music_bkav/Bloc_Search/Search_Bloc.dart';
import 'package:app_music_bkav/Bloc_Search/search_repository.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Bloc_music/Music_Bloc.dart';
import 'package:app_music_bkav/Model/music_model.dart';

import 'package:app_music_bkav/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
Future<void> main() async{
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TimerCubit>(create: (ctx) => TimerCubit()),
      BlocProvider<BlocMusic>(create: (ctx) => BlocMusic()),

      BlocProvider<SearchBloc>(create: (ctx)=> SearchBloc(searchRepository: SearchRepositoryImpl(),)),
      BlocProvider<FavoriteBloc>(create: (ctx)=> FavoriteBloc()),

    ],
    child: MyApp(),
  ));
}
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
