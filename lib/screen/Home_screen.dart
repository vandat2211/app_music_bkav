import 'dart:async';
import 'dart:typed_data';

import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Widget/list_button.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Music",
          style: TextStyle(
              color: AppColors.styleColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
        final bool isFirstTouchToDetail = state.musicModel.title.isEmpty;
        final Uint8List? imageOfMusic = state.musicModel.artworkWidget;
        final String title = state.musicModel.title;
        final String artist = state.musicModel.artist;
        final String path = state.musicModel.path;
        final int duration = state.musicModel.duration;
        final int id = state.musicModel.id;

        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // customButtonWidget(
                      //   borderwidth: 3,
                      //   isActive: state.musicModel.isFavorite,
                      //   child: IconButton(
                      //     onPressed: () {
                      //   // db.insertData(MusicModel(artworkWidget: imageOfMusic, artist: artist, id: id, path: path, title: title, duration: duration));
                      //   //     setState(() {
                      //   //       isFavorit = !isFavorit;
                      //   //     });
                      //       BlocProvider.of<FavoriteBloc>(context).add(ToggleFavorites(state.musicModel));
                      //     },
                      //     icon:  Icon(
                      //       state.musicModel.isFavorite
                      //       ?Icons.favorite
                      //       :Icons.delete,
                      //       color: AppColors.styleColor,
                      //     ),
                      //   ),
                      // ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 30,
                        onPressed: () {
                          BlocProvider.of<FavoriteBloc>(context).add(ToggleFavorites(state.musicModel));
                        },
                        child: Container(
                          child: Icon(
                            //Icons.playlist_add,
                            state.musicModel.isFavorite
                                ? Icons.favorite
                                : Icons.favorite,
                            color:state.musicModel.isFavorite? Colors.red:Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: isEmptyMusics
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) {
                                    bloc.add(SetValue(isFirstTouchToDetail
                                        ? bloc.musics[0]
                                        : state.musicModel));
                                    return DetailPage(
                                      model: isFirstTouchToDetail
                                          ? bloc.musics[0]
                                          : state.musicModel,
                                      newModel: isFirstTouchToDetail
                                          ? bloc.musics[0]
                                          : state.musicModel,
                                    );
                                  }),
                                );
                              },
                        child: ImageMusicShow(
                          imageOfMusic: imageOfMusic,
                          size: 150,
                        ),
                      ),
                      customButtonWidget(
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              isMuteVolume = !isMuteVolume;
                            });
                            if (isMuteVolume) {
                              await bloc.audioPlayer.setVolume(0);
                            } else {
                              await bloc.audioPlayer.setVolume(1);
                            }
                          },
                          icon: Icon(
                            isMuteVolume ? Icons.volume_mute : Icons.volume_up,
                            color: AppColors.styleColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: isEmptyMusics
                      ? _notFoundMusic()
                      : ListOfSong(currentPlayMusic: state.musicModel),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListButton(currentPlayMusic:state.musicModel, newModel: state.musicModel ,)
                  ),
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
