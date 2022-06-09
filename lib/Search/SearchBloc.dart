import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Search/SearchEvent.dart';
import 'package:app_music_bkav/Search/SearchState.dart';
import 'package:app_music_bkav/Search/search_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchRepository}) : super(SearchUninitialized()){
    on<SearchEventLoadData>(_mapEventToState);
  }
  SearchRepository searchRepository;
  void _mapEventToState(SearchEventLoadData event,Emitter<SearchState> emit) async{
    List<MusicModel> song=await searchRepository.getSong(event.query);
    emit(SearchLoad(song: song),);

  }

}

