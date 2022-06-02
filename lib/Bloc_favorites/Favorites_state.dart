import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FavoriteState extends Equatable {
  List<MusicModel> favoriteList;

  FavoriteState({required this.favoriteList});
  static FavoriteState initialState() =>
      FavoriteState(favoriteList: []  );
  FavoriteState copyWith(
      {
         required List<MusicModel> favoritesList}) {
    return FavoriteState(favoriteList: favoriteList
         );
  }
  @override
  List<Object> get props => [favoriteList];
}
