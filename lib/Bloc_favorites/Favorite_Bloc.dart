

import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Favorite_Even.dart';
import 'Favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc():super(FavoriteState(favoriteList: []));
  FavoriteState get initialState => FavoriteState.initialState();
  @override
  Stream<FavoriteState> mapEventToState(
      FavoriteEvent event,
      ) async* {
    if (event is ToggleFavorites) {
      yield* _addToFavorites(event);
    }
  }

  Stream<FavoriteState> _addToFavorites(ToggleFavorites event) async* {
    final int index = this
        .state
        .favoriteList
        .indexWhere((item) => item.id == event.musicModel.id);

    if (index == -1) {
      final favorites = List<MusicModel>.from(this.state.favoriteList);
      favorites.add(event.musicModel);
      event.musicModel.isFavorite = true;

      yield this.state.copyWith( favoritesList: favorites);
    } else {
      final favorites = List<MusicModel>.from(this.state.favoriteList);
      favorites.removeAt(index);
      event.musicModel.isFavorite = false;

      yield this.state.copyWith( favoritesList: favorites);
    }
}}