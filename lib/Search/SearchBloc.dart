import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Search/SearchEvent.dart';
import 'package:app_music_bkav/Search/SearchState.dart';
import 'package:app_music_bkav/Search/search_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchRepository}) : super(SearchUninitialized()){
    on<SearchEventLoadData>((event, emit) { mapEventToState(event);});
  }
  SearchState get initialState => SearchUninitialized();
  SearchRepository searchRepository;
  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async*{
    if(event is SearchEventLoadData){
     yield SearchUninitialized();
    try{
      List<MusicModel> song=await searchRepository.getSong(event.query);
     yield SearchLoad(song: song);
    }catch(e){
     yield SearchError();
    }
  }
  }

}

