

import 'package:app_music_bkav/Bloc_favorites/Favorite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Favorite_Even.dart';
import 'Favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc():super(FavoriteLoading())
  {
    on<StartFavorite>((event, emit){
      _mapStartFavoriteState();
    });
    on<AddFavorites>((event, emit) {
      event.musicModel.isFavorite=true;
     _mapAddFavorite(event, state);

    });
    on<RemoveFavorites>((event, emit) {
      _mapRemoveFavorite(event, state);
      event.musicModel.isFavorite=false;
    });
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
