import 'package:app_music_bkav/Model/music_model.dart';

class BlocState{
  final MusicModel musicModel;
  List<MusicModel>? favorites;
  final bool isOneLoopPlaying;
  BlocState(this.musicModel,{this.isOneLoopPlaying=false});
}
class load extends BlocState{
  load(super.musicModel);
  @override
  List<Object> get props => [];
}