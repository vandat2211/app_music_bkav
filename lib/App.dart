import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/screen/FavoriteScreen.dart';
import 'package:app_music_bkav/screen/Home_screen.dart';
import 'package:app_music_bkav/screen/ProfileScreen.dart';
import 'package:app_music_bkav/screen/SearchScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
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
            artworkWidget:artWork);
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

  final tabs = [
    HomeScreen(
      musics: [],
    ),
    SearchScreen(musics: [],),
    FavoriteScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? (isLoading
              ? const Scaffold(
                  backgroundColor: AppColors.mainColor,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : HomeScreen(
                  musics: provider.musics.isEmpty
                      ? ([
                          MusicModel(
                              artworkWidget: null,
                              artist: "Not Found",
                              id: 0,
                              duration: 0,
                              path: "",
                              title: "Not Found"),
                        ])
                      : provider.musics,
                ))
          : tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue)
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
