import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent{}
  class Favorite extends FavoriteEvent{
  final MusicModel music;
  Favorite(this.music);
  }