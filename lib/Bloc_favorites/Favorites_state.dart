import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

 class FavoriteState extends Equatable {
  final List<MusicModel> music;
  const FavoriteState({
    this.music=const<MusicModel>[]
});

  @override
  List<Object> get props=>[music];
}

