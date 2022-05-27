import 'package:app_music_bkav/App.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/screen/Home_screen.dart';
import 'package:app_music_bkav/timer_cubit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audiotagger/audiotagger.dart';
void main() => runApp(MultiBlocProvider(
  providers: [
    BlocProvider<BlocMusic>(create: (ctx) => BlocMusic()),
    BlocProvider<TimerCubit>(create: (ctx) => TimerCubit()),
  ],
  child: MyApp(),
));
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AudioPlayer audioPlayer;
  late BlocMusic provider;
  late OnAudioQuery onAudioQuery;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    onAudioQuery = OnAudioQuery();
    _getMusicsFromStorage();
    provider = BlocProvider.of<BlocMusic>(context);
    audioPlayer = AudioPlayer();
  }
  void _getMusicsFromStorage() async {
    Audiotagger audiotagger = Audiotagger();
    final List<MusicModel> musics = [];
    final songs = await onAudioQuery.querySongs();
    for (var element in songs) {
      if (element.duration != null && element.duration != 0) {
        final artWork = await audiotagger.readArtwork(path: element.data);
        final music = MusicModel(
            artist: element.artist!,
            id: element.id,
            path: element.data,
            title: element.title,
            duration: element.duration!,
            artworkWidget: artWork != null ? Image.memory(artWork) : null);
        musics.add(music);
        await Future.delayed(
            const Duration(microseconds: 10)); // this is for complete ui
      }
    }
    provider.getListOfMusicModel = musics; // provider is bloc music
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:  isLoading
      //     ? const Scaffold(
      //   backgroundColor: AppColors.mainColor,
      //   body: Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // )
      //     : HomeScreen(
      //   musics: provider.musics.isEmpty
      //       ? ([
      //     MusicModel(
      //         artworkWidget: null,
      //         artist: "Not Found",
      //         id: 0,
      //         duration: 0,
      //         path: "",
      //         title: "Not Found"),
      //   ])
      //       : provider.musics,
      // ),
      home: App(),
    );
  }
}
