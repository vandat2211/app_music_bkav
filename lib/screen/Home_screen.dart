
import 'dart:typed_data';
import 'package:app_music_bkav/Bloc_music/Music_Bloc.dart';
import 'package:app_music_bkav/Bloc_music/Music_State.dart';
import 'package:app_music_bkav/ReponsiverWidget.dart';
import 'package:app_music_bkav/Widget/deltail.dart';
import 'package:app_music_bkav/Widget/Button_PlayMedia.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/Widget/list_songs.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final List<MusicModel>? musics;
  const HomeScreen({Key? key, this.musics}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Permission.storage.request();

  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bool isEmptyMusics = bloc.musics.first.path.isEmpty;
    return Scaffold(
      body: SafeArea(
        child: ReponsiveWidget(
          mobile: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
            final bool isFirstTouchToDetail = state.musicModel.title.isEmpty;
            final Uint8List? imageOfMusic = state.musicModel.artworkWidget;

            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: isEmptyMusics
                          ? _notFoundMusic()
                          : ListOfSongSearch(
                              currentPlayMusic: state.musicModel),
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
          tab: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
            final bool isFirstTouchToDetail = state.musicModel.title.isEmpty;
            final Uint8List? imageOfMusic = state.musicModel.artworkWidget;

            return Row(
              children: <Widget>[
                Container(
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: isEmptyMusics
                            ? _notFoundMusic()
                            : ListOfSong(currentPlayMusic: state.musicModel),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 470,
                  child: Detail(
                    model: state.musicModel,
                    newModel: state.musicModel,
                  ),
                )
              ],
            );
          }),
        ),
      ),
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
