import 'package:app_music_bkav/Model/music_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}
class SearchUninitialized extends SearchState{
  @override
  List<Object> get props => [];
}
class SearchLoad extends SearchState{
  List<MusicModel> song;
  SearchLoad({required this.song});
  @override
  List<Object> get props => [song];
}
class SearchError extends SearchState{
  @override
  List<Object> get props => [];
}

