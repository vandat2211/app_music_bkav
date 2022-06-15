
import 'package:app_music_bkav/Bloc_music/Music_Event.dart';
import 'package:app_music_bkav/Bloc_music/Music_State.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../Model/music_model.dart';
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
  bool isEnd(int id) {
    '''pass id and find location of music and get is end of list of musics or not''';
    final index = _model.indexWhere((element) => element.id == id);
    if (index == _model.length - 1) {
      return true;
    } else {
      return false;
    }
  }
  bool isStart(int id) {
    '''pass id and find location of music and get is start of list of musics or not''';
    final index = _model.indexWhere((element) => element.id == id);
    if (index == 0) {
      return true;
    } else {
      return false;
    }
  }
  MusicModel playNext(int id) {
    '''pass id and get get next Music Modle 
    Note: please before use it use isEnd method
    ''';
    final index = _model.indexWhere((element) => element.id == id);
    return _model[index + 1];
  }
  MusicModel playPrevious(int id) {
    '''pass id and get get previous Music Modle 
    Note: please before use it use isStart method
    ''';
    final index = _model.indexWhere((element) => element.id == id);
    return _model[index - 1];
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
      }else{
        add(StopMusic());
      }
    });
  }

  BlocMusic():super(BlocState(MusicModel.first())){
    on<BlocEvent>((event,emit) async{
      if (event is SkipNextMusic) {
        if (!isEnd(event.nextMusicId)) {
          final playingThisMusic =
          _model[findIndex(event.nextMusicId) + 1]; // next music

          await _audioPlayer.play(playingThisMusic.path, isLocal: true);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
        }
      } else if (event is SkipPreviousMusic) {
        if (!isStart(event.previousMusicId)) {
          final playingThisMusic =
          _model[findIndex(event.previousMusicId) - 1]; // previous music

          await _audioPlayer.play(playingThisMusic.path);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
        }
      } else if (event is PlayMusic) {
        final readyToPlayMusic = findById(event.musicId);
        await _audioPlayer.play(readyToPlayMusic.path, isLocal: true);
        MediaItem(id: '${event.musicId}', title: "dat");
        _whenCompleteMusic();
        emit(BlocState(readyToPlayMusic, isOneLoopPlaying: _isOneLoopPlaying));
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
      } else {
        await _audioPlayer.stop();
        emit(BlocState(state.musicModel));
      }
    });
  }

}