import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

 class FavoriteState extends Equatable{
  final List<MusicModel> favorites;
   FavoriteState(@required this.favorites);
  FavoriteState copyWith({required List<MusicModel> favorites}){
    return FavoriteState(favorites);
  }
  @override
  List<Object?> get props => [favorites];

}