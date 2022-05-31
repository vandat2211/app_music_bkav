import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/timer_cubit.dart';
import '../resource/Color_manager.dart';
import 'custom_button_widge.dart';

class ListButton extends StatefulWidget {
  final MusicModel currentPlayMusic;
  final MusicModel newModel;
  const ListButton(
      {Key? key, required this.currentPlayMusic, required this.newModel})
      : super(key: key);

  @override
  State<ListButton> createState() => _ListButtonState();
}

class _ListButtonState extends State<ListButton>
    with SingleTickerProviderStateMixin {
  late BlocMusic _blocMusic;
  bool _isPlaying = false;
  late AnimationController _controller;
  late TimerCubit _timerCubit;
  late MusicModel modelState;
  late MusicModel musicModelNew;
  @override
  void initState() {
    super.initState();
    _blocMusic = BlocProvider.of<BlocMusic>(context);
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    modelState = widget.currentPlayMusic;
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
    return BlocConsumer<BlocMusic, BlocState>(
      listener: (context, state) {},
      builder: (c, state) =>
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
            onPressed: () async {
              _blocMusic.add(SkipPreviousMusic(state.musicModel.id));
              setState(() {
                _isPlaying = true;
              });
            },
            icon: Icon(Icons.skip_previous)),
        customButtonWidget(
          borderwidth: 0,
          isActive: true,
          size: 50,
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
                  _blocMusic.add(PlayMusic(state.musicModel.id));

                  setState(() {
                    _isPlaying = true;
                  });
                  _controller.forward();
                } else if (musicModelNew != modelState) {
                  _blocMusic.add(PlayMusic(state.musicModel.id));
                  modelState = musicModelNew;

                  setState(() {
                    _isPlaying = true;
                  });
                  _controller.forward();
                } else if (_blocMusic.audioPlayer.state ==
                    PlayerState.STOPPED) {
                  _blocMusic.add(PlayMusic(state.musicModel.id));
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
        IconButton(
            onPressed: () async {
              _blocMusic.add(SkipNextMusic(state.musicModel.id));
            },
            icon: Icon(Icons.skip_next)),
      ]),
    );
  }
}
