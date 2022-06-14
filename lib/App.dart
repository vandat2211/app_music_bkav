import 'package:app_music_bkav/Bloc_music/Music_Bloc.dart';
import 'package:app_music_bkav/ReponsiverWidget.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/screen/FavoriteScreen.dart';
import 'package:app_music_bkav/screen/Home_screen.dart';
import 'package:app_music_bkav/screen/SearchScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 1;
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
            artworkWidget: artWork);
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
    SearchScreen(
      musics: [],
    ),
    HomeScreen(
      musics: [],
    ),
    FavoriteScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 1
          ? (isLoading
              ? const Scaffold(
                  backgroundColor: Colors.white,
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
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.orangeAccent,
        color: Colors.white,
        activeColor: Colors.white,
        gap: 8,
        padding: EdgeInsets.all(16),
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        tabBackgroundColor: Colors.orange,
        tabs: [
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.favorite,
            text: 'Favorite',
          )
        ],
      ),
    );
  }
}
