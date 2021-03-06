import 'package:app_music_bkav/Model/music_model.dart';

abstract class BlocEvent{}
class PlayMusic extends BlocEvent{
  final int musicId;
  PlayMusic(this.musicId);
}
class SkipNextMusic extends BlocEvent {
  final int nextMusicId;

  SkipNextMusic(this.nextMusicId);
}
class RandumMusic extends BlocEvent {
}
class SkipPreviousMusic extends BlocEvent {
  final int previousMusicId;

  SkipPreviousMusic(this.previousMusicId);
}

class PauseResumeMusic extends BlocEvent {

}

class StopMusic extends BlocEvent {}

class SetValue extends BlocEvent {
  final MusicModel musicModel;
  SetValue(this.musicModel);
}