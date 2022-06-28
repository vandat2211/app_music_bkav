
import 'dart:math';


import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../Model/music_model.dart';
import 'music_event.dart';
import 'music_state.dart';
class BlocMusic extends Bloc<BlocEvent,BlocState>{
  List<MusicModel> _model = [];
  final AudioPlayer _audioPlayer=AudioPlayer(playerId: "Base");

  bool _isOneLoopPlaying = false;
  bool _isOneshuffle = false;
  set getListOfMusicModel(List<MusicModel> musics) {
    _model = musics;
  }
  AudioPlayer get audioPlayer{
    return _audioPlayer;
  }
  List<MusicModel> get musics{
    return _model;//danh sachs bai hat tren dien thoai
  }
  MusicModel findById(int id){
    final music=_model.firstWhere((element) => element.id == id);
    return music;
    //
  }
  int findIndex(int id){
    final music = _model.indexWhere((element) => element.id == id);
    return music;
  }
  set isOneLoopPlayingSet(bool isOneLoopPlayingArg) {
    _isOneLoopPlaying = isOneLoopPlayingArg;
  }
  bool get isOneLoopPlaying {
    return _isOneLoopPlaying;
  }
  set isOneshuffleSet(bool isOneshuffleArg) {
    _isOneshuffle = isOneshuffleArg;
  }
  bool get isOneshuffle {
    return _isOneshuffle;
  }
  void _whenCompleteMusic(){
    _audioPlayer.onPlayerCompletion.listen((event) {
      if(_isOneLoopPlaying){
        add(PlayMusic(state.musicModel.id));
      }
      else if(_isOneshuffle){
        add(RandumMusic());
      }
      else{
        add(SkipNextMusic(state.musicModel.id));
      }
    });
  }
  BlocMusic():super(BlocState(MusicModel.first())){
    on<BlocEvent>((event,emit) async{
      if (event is SkipNextMusic) {
        if (findIndex(event.nextMusicId) == _model.length-1) {
          final playingThisMusic = _model[0];
          await _audioPlayer.play(playingThisMusic.path, isLocal: true);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));
        }
        else {
          final playingThisMusic =
          _model[findIndex(event.nextMusicId) + 1];
          await _audioPlayer.play(playingThisMusic.path, isLocal: true);
          emit(
              BlocState(playingThisMusic ,isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));
        }
      }
      else if (event is SkipPreviousMusic) {
        if(findIndex(event.previousMusicId)==0) {
          final playingThisMusic =
          _model[_model.length - 1]; // previous music

          await _audioPlayer.play(playingThisMusic.path);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));
        }
        else{
          final playingThisMusic =
          _model[findIndex(event.previousMusicId) - 1]; // previous music

          await _audioPlayer.play(playingThisMusic.path);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));
        }
      } else if (event is RandumMusic) {
        // final _random=new Random();
        //   final playingThisMusic =
        //   _model[_random.nextInt(_model.length)];
        var playingThisMusic = (_model.toList()..shuffle()).first;
          await _audioPlayer.play(playingThisMusic.path, isLocal: true);
          emit(
              BlocState(playingThisMusic ,isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));

      }
      else if (event is PlayMusic) {
        final readyToPlayMusic = findById(event.musicId);
        await _audioPlayer.play(readyToPlayMusic.path, isLocal: true);
        MediaItem(id: '${event.musicId}', title: "dat");
        _whenCompleteMusic();
        emit(BlocState(readyToPlayMusic, isOneLoopPlaying: _isOneLoopPlaying,isOnelap: _isOneshuffle));
      } else if (event is PauseResumeMusic) {
        if (_audioPlayer.state == PlayerState.PAUSED) {
          await _audioPlayer.resume();
          _whenCompleteMusic();
        } else {
          await _audioPlayer.pause();
        }
        emit(BlocState(state.musicModel));
      } else if (event is SetValue) {
        emit(BlocState(event.musicModel));
      }
     else {
        await _audioPlayer.stop();
        emit(BlocState(state.musicModel));
      }
    });
  }

}