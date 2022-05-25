import 'dart:async';


import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    final bloc= BlocProvider.of<BlocMusic>(context);
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
      final Image? imageOfMusic = state.musicModel.artworkWidget;
      return Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    customButtonWidget(
                      borderwidth: 3,
                      isActive: isFavorit,
                      child: IconButton(
                        onPressed: () {
                          // I will Update Favorit button
                          setState(() {
                            isFavorit = !isFavorit;
                          });
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: AppColors.styleColor,
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
                              // model: isFirstTouchToDetail
                              //     ? bloc.musics[0]
                              //     : state.modelState,
                              // newModel: isFirstTouchToDetail
                              //     ? bloc.musics[0]
                              //     : state.modelState,
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
              Container(
                height: 60,
                width: 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: AppColors.activeColor,
                  border: Border.all(color: AppColors.mainColor),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkBlue,
                          borderRadius: BorderRadius.circular(65),
                        ),
                        width: 145,
                        height: 60,
                      ),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "All",
                            style:
                            TextStyle(
                              fontSize: 19,
                                fontWeight : FontWeight.w600,
                                color:AppColors.activeColor
                            ),
                          ),
                          Text(
                            "Favorite",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight : FontWeight.w400,
                                color:AppColors.styleColor
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              Expanded(
                child: isEmptyMusics
                    ? _notFoundMusic()
                    : ListOfSong(currentPlayMusic: state.musicModel),
              ),
            ],
          ),
          _bottomShadow()
        ],
      );
      }
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
        fontWeight : FontWeight.w600,
        color:AppColors.styleColor
    ),
    ),
    ),
    );
    }

        Widget _bottomShadow() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Text(
           "Powered by Adnan",
            style: TextStyle(
                fontSize : 16,
                fontWeight : FontWeight.w400,
                color :AppColors.styleColor
            ),
          ),
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.mainColor.withOpacity(0),
              AppColors.mainColor.withOpacity(0.75),
              AppColors.mainColor
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      );
    }
}
