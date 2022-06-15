import 'dart:async';
import 'dart:typed_data';

import 'package:app_music_bkav/Bloc_music/Music_Event.dart';
import 'package:app_music_bkav/Bloc_music/Music_Bloc.dart';
import 'package:app_music_bkav/Bloc_music/Music_State.dart';
import 'package:app_music_bkav/ReponsiverWidget.dart';
import 'package:app_music_bkav/Widget/deltail.dart';
import 'package:app_music_bkav/Widget/list_button.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/timer_cubit.dart';
import 'package:audioplayers/audioplayers_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


class HomeScreen extends StatefulWidget {
  final List<MusicModel> musics;
  const HomeScreen({Key? key, required this.musics}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration _duration = Duration.zero;
  late BlocMusic _blocMusic;
  late TimerCubit _timerCubit;
  bool isFavorit = false;
  bool _isPlaying = false;
  String id = "";
  @override
  void initState() {
    super.initState();
    Permission.storage.request();
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _blocMusic = BlocProvider.of<BlocMusic>(context);
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
                                : ListOfSong(
                                    currentPlayMusic: state.musicModel),
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     SizedBox(
                    //       child: ImageMusicShow(
                    //         imageOfMusic: state.musicModel.artworkWidget,
                    //         size: 80,
                    //         borderRadius: BorderRadius.circular(50),
                    //       ),
                    //     ),
                    //     Text(
                    //       state.musicModel.title,
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           color: AppColors.styleColor,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //     Text(
                    //       state.musicModel.artist,
                    //       style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w400,
                    //           color: AppColors.styleColor),
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         BlocConsumer<TimerCubit, Duration>(
                    //             listener: (context, state) async {},
                    //             builder: (context, state) {
                    //               _duration = state;
                    //               _duration = Duration.zero;
                    //               return Expanded(
                    //                 child: Text(
                    //                   "${_duration.inMinutes > 9 ? _duration.inMinutes : '0' + _duration.inMinutes.toString()}:${_duration.inSeconds % 60 > 9 ? _duration.inSeconds % 60 : '0' + (_duration.inSeconds % 60).toString()}",
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black),
                    //                 ),
                    //               );
                    //             }),
                    //         Text(
                    //           "${state.musicModel.duration ~/ 60000 > 9 ? state.musicModel.duration ~/ 60000 : '0' + (state.musicModel.duration ~/ 60000).toString()}:${(state.musicModel.duration ~/ 1000) % 60 > 9 ? (state.musicModel.duration ~/ 1000) % 60 : '0' + (state.musicModel.duration ~/ 1000 % 60).toString()}",
                    //           style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black),
                    //         ),
                    //       ],
                    //     ),
                    //     BlocConsumer<TimerCubit, Duration>(
                    //         listener: (context, states) {},
                    //         builder: (context, states) {
                    //           return _musicSeekTime(context,
                    //               maxDuration: state.musicModel.duration);
                    //         }),
                    //     _playButtonsAction(state.musicModel.id),
                    //   ],
                    // ),
                   Container(
                     width: 470,
                     child: Detail(model: state.musicModel,newModel: state.musicModel,),
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

  SfSliderTheme _musicSeekTime(BuildContext context, {int? maxDuration}) {
    return SfSliderTheme(
      data: SfSliderTheme.of(context).copyWith(
          thumbStrokeWidth: 8,
          activeDividerColor: Colors.red,
          inactiveDividerColor: Colors.red,
          thumbColor: Colors.red,
          thumbRadius: 10,
          activeTrackColor: Colors.red),
      child: SfSlider(
        max: Duration(milliseconds: maxDuration!).inSeconds,
        min: 0,
        value: _duration.inSeconds,
        onChanged: (v) {
          // used for change time of music

          _blocMusic.audioPlayer.seek(Duration(seconds: (v ~/ 1) - 2));
        },
      ),
    );
  }

  Widget _playButtonsAction(int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // previous button
          customButtonWidget(
            size: 70,
            child: IconButton(
              onPressed: () async {
                _blocMusic.add(SkipPreviousMusic(id));
                setState(() {
                  _isPlaying = true;
                });
              },
              icon: const Icon(Icons.skip_previous),
            ),
          ),
          // play button
          customButtonWidget(
            borderwidth: 0,
            isActive: true,
            size: 80,
            child: BlocListener<BlocMusic, BlocState>(
              bloc: _blocMusic,
              listener: (context, state) {
                if (_blocMusic.audioPlayer.state == PlayerState.STOPPED) {
                  setState(() {
                    _isPlaying = false;
                    _blocMusic.audioPlayer.seek(Duration.zero);
                  });
                }
              },
              child: IconButton(
                  onPressed: () async {
                    // send event to bloc to play or pause
                    if (_blocMusic.audioPlayer.state == PlayerState.COMPLETED) {
                      _blocMusic.add(PlayMusic(id));

                      setState(() {
                        _isPlaying = true;
                      });
                    } else if (_blocMusic.audioPlayer.state ==
                        PlayerState.STOPPED) {
                      _blocMusic.add(PlayMusic(id));
                      setState(() {
                        _isPlaying = true;
                      });
                    } else {
                      _blocMusic.add(PauseResumeMusic());
                      // this Future for complete progress and supply audio player true value
                      await Future.delayed(
                        const Duration(milliseconds: 300),
                      );
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    }
                  },
                  icon: Icon(Icons.pause)),
            ),
          ),
          // next button
          customButtonWidget(
            size: 70,
            child: IconButton(
              onPressed: () async {
                _blocMusic.add(SkipNextMusic(id));
              },
              icon: const Icon(Icons.skip_next),
            ),
          ),
          customButtonWidget(
            size: 70,
            child: IconButton(
              onPressed: () {
                _blocMusic.isOneLoopPlayingSet = !_blocMusic.isOneLoopPlaying;
                setState(() {});
              },
              icon: Icon(
                Icons.repeat,
                color: _blocMusic.isOneLoopPlaying
                    ? AppColors.darkBlue
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
