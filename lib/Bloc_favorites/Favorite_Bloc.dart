

import 'package:app_music_bkav/Bloc_favorites/Favorite.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Favorite_Even.dart';
import 'Favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc():super(FavoriteLoading());
  Stream<FavoriteState> mapEventToState(FavoriteEvent event)async* {
    if (event is StartFavorite) {
      yield* _mapStartFavoriteState();
    } else if (event is AddFavorites) {
      yield* _mapAddFavorite(event, state);
    } else if (event is RemoveFavorites) {
      yield* _mapRemoveFavorite(event, state);
    }
  }
    Stream<FavoriteState> _mapStartFavoriteState()async*{
      yield FavoriteLoading();
      try{
        await Future<void>.delayed(const Duration(seconds: 1));
        yield const FavoriteLoaded();
      }catch(_){}
    }
    Stream<FavoriteState> _mapAddFavorite(AddFavorites event,FavoriteState state)async*{
      if(state is FavoriteLoaded){
        try{
          yield FavoriteLoaded(favorite: Favorite(music: List.from(state.favorite.music)..add(event.musicModel),),);
        }catch(_){}
      }
    }

    Stream<FavoriteState> _mapRemoveFavorite(RemoveFavorites event,FavoriteState state)async*{
      if(state is FavoriteLoaded){
        try{
          yield FavoriteLoaded(favorite: Favorite(music: List.from(state.favorite.music)..remove(event.musicModel),),);
        }catch(_){}
      }
    }
  }
