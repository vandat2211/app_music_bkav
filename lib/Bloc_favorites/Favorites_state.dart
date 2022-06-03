import 'package:app_music_bkav/Bloc_favorites/Favorite.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props=>[];
}
 class FavoriteLoading extends FavoriteState{}
 class FavoriteLoaded extends FavoriteState{
  final Favorite favorite;
  const FavoriteLoaded({this.favorite=const Favorite()});

  @override
  List<Object> get props=>[favorite];
 }
 class FavoriteError extends FavoriteState{}


