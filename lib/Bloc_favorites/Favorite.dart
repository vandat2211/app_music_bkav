import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';

class Favorite extends Equatable{
  final List<MusicModel> music;
  const Favorite({this.music=const<MusicModel>[]});
  @override
  List<Object?> get props=> [music];
}