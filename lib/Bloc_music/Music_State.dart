import 'package:app_music_bkav/Model/music_model.dart';

class BlocState{
  final MusicModel musicModel;
  final bool isOneLoopPlaying;
  final bool isOnelap;
  BlocState(this.musicModel,{this.isOneLoopPlaying=false,this.isOnelap=false});
}