import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Widget/image_music_shower.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/custom_progress_widget.dart';
import 'package:app_music_bkav/timer_cubit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailPage extends StatefulWidget {
  final MusicModel model;
  final MusicModel newModel;
  const DetailPage({Key? key, required this.model, required this.newModel})
      : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  int _id = 0;
  late TimerCubit _timerCubit;
  late AnimationController _controller;
  late MusicModel modelState;
  late BlocMusic _blocMusic;
  late int maxDuration;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  late MusicModel musicModelNew;
  @override
  void initState() {
    super.initState();
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _blocMusic = BlocProvider.of<BlocMusic>(context);
    modelState = widget.model;
    maxDuration = widget.newModel.duration;
    musicModelNew = modelState;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayer = _blocMusic.audioPlayer;
    final isNowPlaying = _audioPlayer.state == PlayerState.PLAYING;
    _timerCubit.timer(_audioPlayer.onAudioPositionChanged);
    if (isNowPlaying && modelState == widget.newModel) {
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
    } else if (isNowPlaying && modelState != widget.newModel) {
      _blocMusic.add(PlayMusic(widget.newModel.id));
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
      modelState = widget.newModel;
      musicModelNew = modelState;
    } else {
      musicModelNew = widget.newModel;
    }
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, contrains) {
            return BlocConsumer<BlocMusic, BlocState>(
              listener: ((context, stateBlocMusic) {
                _id = stateBlocMusic.musicModel.id;
                maxDuration = stateBlocMusic.musicModel.duration;
              }),
              builder: (c, state) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(contrains.maxHeight * 0.010),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customButtonWidget(
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.styleColor,
                            ),
                          ),
                        ),
                        Text(
                          "PLAYING NOW",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w300,
                              color: AppColors.styleColor),
                          // style: getTitileStyle(fontWeight: FontWeight.w300),
                        ),
                        customButtonWidget(
                          child: IconButton(
                            onPressed: () {
                              state.musicModel.isFavorite ? {BlocProvider.of<FavoriteBloc>(context)
                                  .add(RemoveFavorites( state.musicModel)),
                                // db.delete(_muicIndex.id)
                              }
                                  : {BlocProvider.of<FavoriteBloc>(context)
                                  .add(AddFavorites( state.musicModel)),
                                // db.insertData(_muicIndex)
                              };
                              setState((){});
                            },
                            icon: Icon(Icons.favorite,
                                color: state.musicModel.isFavorite
                                    ? Colors.red
                                    : Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: contrains.maxHeight * 0.35,
                    height: contrains.maxHeight * 0.35,
                    child: ImageMusicShow(
                      imageOfMusic: state.musicModel.artworkWidget,
                      size: 230,
                    ),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.040,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: contrains.maxWidth * 0.048),
                    child: Text(
                      state.musicModel.title,
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColors.styleColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.01,
                  ),
                  Text(
                    state.musicModel.artist,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.styleColor),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.020,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: contrains.maxWidth * 0.05,
                      ),
                      BlocConsumer<TimerCubit, Duration>(
                          listener: (context, state) async {},
                          builder: (context, state) {
                            _duration = state;
                            if (modelState.id != widget.newModel.id) {
                              _duration = Duration.zero;
                            }
                            return Expanded(
                              child: Text(
                                "${_duration.inMinutes > 9 ? _duration.inMinutes : '0' + _duration.inMinutes.toString()}:${_duration.inSeconds % 60 > 9 ? _duration.inSeconds % 60 : '0' + (_duration.inSeconds % 60).toString()}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.styleColor),
                              ),
                            );
                          }),
                      Text(
                        "${state.musicModel.duration ~/ 60000 > 9 ? state.musicModel.duration ~/ 60000 : '0' + (state.musicModel.duration ~/ 60000).toString()}:${(state.musicModel.duration ~/ 1000) % 60 > 9 ? (state.musicModel.duration ~/ 1000) % 60 : '0' + (state.musicModel.duration ~/ 1000 % 60).toString()}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.styleColor),
                      ),
                      SizedBox(
                        width: contrains.maxWidth * 0.05,
                      ),
                    ],
                  ),
                  BlocConsumer<TimerCubit, Duration>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return _musicSeekTime(context,
                            maxDuration: maxDuration);
                      }),
                  _playButtonsAction(state.musicModel.id),
                  _loopButton()
                ],
              ),
            );
          },
        ),
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
                  _controller.reverse();
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
                    _controller.forward();
                  } else if (musicModelNew != modelState) {
                    _blocMusic.add(PlayMusic(id));
                    modelState = musicModelNew;

                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.forward();
                  } else if (_blocMusic.audioPlayer.state ==
                      PlayerState.STOPPED) {
                    _blocMusic.add(PlayMusic(id));
                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.forward();
                  } else {
                    _blocMusic.add(PauseResumeMusic());
                    // this Future for complete progress and supply audio player true value
                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    );
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });

                    if (_isPlaying) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  }
                },
                icon: AnimatedIcon(
                  progress: _controller,
                  icon: AnimatedIcons.play_pause,
                  color: _isPlaying ? Colors.white : AppColors.styleColor,
                ),
              ),
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
        ],
      ),
    );
  }

  Padding _loopButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          onPressed: () {
            _blocMusic.isOneLoopPlayingSet = !_blocMusic.isOneLoopPlaying;
            setState(() {});
          },
          icon: Icon(
            Icons.loop,
            color: _blocMusic.isOneLoopPlaying
                ? AppColors.darkBlue
                : AppColors.styleColor,
          ),
        ),
      ),
    );
  }

  SfSliderTheme _musicSeekTime(BuildContext context, {int? maxDuration}) {
    return SfSliderTheme(
      data: SfSliderTheme.of(context).copyWith(
        thumbStrokeWidth: 8,
        thumbStrokeColor: AppColors.mainColor,
        activeDividerColor: AppColors.styleColor,
        inactiveDividerColor: AppColors.styleColor.withAlpha(90),
        thumbColor: AppColors.darkBlue,
        thumbRadius: 15,
      ),
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
}
