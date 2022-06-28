import 'dart:typed_data';

import 'package:app_music_bkav/Bloc_favorites/favorite_bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/favorite_even.dart';

import 'package:app_music_bkav/database/database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/reponsiverWidget.dart';
import 'package:app_music_bkav/Widget/image_music_shower.dart';
import 'package:app_music_bkav/screen/musicplayerscreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc_music/music_bloc.dart';
import '../bloc_music/music_event.dart';
import '../bloc_music/music_state.dart';
import '../resource/Color_manager.dart';
import 'custom_button_widge.dart';

class ListOfSongSearch extends StatefulWidget {
  final MusicModel? currentPlayMusic;
  const ListOfSongSearch({Key? key, this.currentPlayMusic}) : super(key: key);

  @override
  State<ListOfSongSearch> createState() => _ListOfSongSearchState();
}

class _ListOfSongSearchState extends State<ListOfSongSearch>
    with SingleTickerProviderStateMixin {
  int _id = 0;
  late AnimationController _controller;
  bool isSelected = false;
  String stringValue = "No value";
  @override
  void initState() {
    super.initState();
    getAllSavedData();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? value = prefs.getBool("youKey");

    if (value != null) stringValue = value.toString();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.musics.length,
        itemBuilder: (ctx, index) {
          final MusicModel _muicIndex = bloc.musics[index];
          return BlocListener<BlocMusic, BlocState>(
            bloc: bloc,
            listener: (context, state) {
              if (bloc.audioPlayer.state == PlayerState.PLAYING) {
                _id = state.musicModel.id;
                _controller.forward();
              } else {
                Future.delayed(const Duration(milliseconds: 400)).then((value) {
                  setState(() {
                    _id = 0;
                  });
                });
                _controller.reverse();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: _id == _muicIndex.id
                      ? Colors.orangeAccent[100]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () async {
                  if (bloc.audioPlayer.state != PlayerState.PLAYING) {
                    bloc.add(PlayMusic(_muicIndex.id));

                    _controller.forward();
                    setState(() {
                      _id = _muicIndex.id;
                    });
                  } else if (bloc.audioPlayer.state == PlayerState.PLAYING &&
                      widget.currentPlayMusic != _muicIndex) {
                    bloc.add(PlayMusic(_muicIndex.id));
                    _controller.forward();
                    setState(() {
                      _id = _muicIndex.id;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: ImageMusicShow(
                              imageOfMusic: _muicIndex.artworkWidget,
                              size: 50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _muicIndex.title.length < 40
                                    ? _muicIndex.title
                                    : _muicIndex.title.substring(15),
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.styleColor,
                                ),
                              ),
                              Text(
                                _muicIndex.artist,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.styleColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: _id == _muicIndex.id
                            ? AnimatedIcon(
                                progress: _controller,
                                icon: AnimatedIcons.play_pause,
                                color: _id == widget.currentPlayMusic!.id
                                    ? Colors.black
                                    : AppColors.styleColor,
                              )
                            : (_muicIndex.isFavorite
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(Icons.favorite_border)),
                        onPressed: () async {
                          _id == _muicIndex.id
                          ? {
                          _controller.reverse(),
                          bloc.add(PauseResumeMusic()),
                          Future.delayed(_controller.duration!).then((value) {
                          setState(() {
                          _id = 0;
                          });
                          })
                          }
                          :
                          _muicIndex.isFavorite
                              ? BlocProvider.of<FavoriteBloc>(context)
                                  .add(RemoveFavorites(_muicIndex))
                              : BlocProvider.of<FavoriteBloc>(context)
                                  .add(AddFavorites(_muicIndex));
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("youKey", _muicIndex.isFavorite);

                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
