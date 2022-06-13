import 'dart:async';
import 'dart:typed_data';

import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorites_state.dart';
import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Widget/list_button.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/screen/FavoriteScreen.dart';
import 'package:app_music_bkav/screen/SearchScreen.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widget/image_music_shower.dart';
import '../Widget/list_song.dart';

class HomeScreen extends StatefulWidget {
  final List<MusicModel> musics;
  const HomeScreen({Key? key, required this.musics}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorit = false;
  bool isMuteVolume = false;
  late Timer whenStartTimer;

  String id = "";
  double changeVolume = 0;
  late DB db;
  @override
  void initState() {
    super.initState();
    db = DB();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bool isEmptyMusics = bloc.musics.first.path.isEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
        final bool isFirstTouchToDetail = state.musicModel.title.isEmpty;
        final Uint8List? imageOfMusic = state.musicModel.artworkWidget;

        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: isEmptyMusics
                      ? _notFoundMusic()
                      : ListOfSongSearch(currentPlayMusic: state.musicModel),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListButton(
                        currentPlayMusic: state.musicModel,
                        newModel: state.musicModel,
                      )),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _notFoundMusic() {
    return Scaffold(
      body: Center(
        child: Text(
          "Not Found Music",
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.styleColor),
        ),
      ),
    );
  }
}
