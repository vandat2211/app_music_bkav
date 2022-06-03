import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props=>[];
}
class StartFavorite extends FavoriteEvent{}
class AddFavorites extends FavoriteEvent {
  final MusicModel musicModel;
  const AddFavorites(this.musicModel);
  @override
  List<Object> get props=>[musicModel];
}
class RemoveFavorites extends FavoriteEvent {
  final MusicModel musicModel;
  const RemoveFavorites(this.musicModel);
  @override
  List<Object> get props=>[musicModel];
}