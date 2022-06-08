
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Favorite_Even.dart';
import 'Favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc():super(const FavoriteState())
  {
      on<AddFavorites>(_mapAddFavorite);
      on<RemoveFavorites>(_mapRemove);

  }

    void _mapAddFavorite(AddFavorites event,Emitter<FavoriteState> emit){
    final state=this.state;
    event.musicModel.isFavorite=true;
    emit(FavoriteState(music: List.from(state.music)..add(event.musicModel),));
    }
  void _mapRemove(RemoveFavorites event,Emitter<FavoriteState> emit){
    final state=this.state;
    event.musicModel.isFavorite=false;
    emit(FavoriteState(music: List.from(state.music)..remove(event.musicModel),));
  }


  }
