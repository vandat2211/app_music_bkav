import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FavoriteEvent {}

class ToggleFavorites extends FavoriteEvent {
  final MusicModel musicModel;
  ToggleFavorites(this.musicModel);
}