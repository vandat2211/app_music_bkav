import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class MusicModel {
  final int id;
  final String title;
  final String path;
  final int duration;
  final String artist;
  final Uint8List? artworkWidget;
  bool isFavorite;
  MusicModel.first({
    this.artworkWidget,
    this.artist = "",
    this.duration = 0,
    this.id = 0,
    this.path = "",
    this.title = "",
    this.isFavorite = false,
  });
  MusicModel({
    required this.artworkWidget,
    required this.artist,
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
    this.isFavorite = false,
  });
  factory MusicModel.fromMap(Map<String, dynamic> json) => MusicModel(
      artworkWidget: json["artworkWidget"],
      artist: json["artist"],
      id: json['id'],
      path: json["path"],
      title: json["title"],
      duration: json['duration']);
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "artist": artist,
        "path": path,
        "artworkWidget": artworkWidget,
        "duration": duration,
      };
  void favoriteMusic() {
    isFavorite = !isFavorite;
  }
}
