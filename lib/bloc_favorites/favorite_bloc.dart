
import 'dart:async';

import 'package:app_music_bkav/database/database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorite_even.dart';
import 'favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  late DB db;
  List<MusicModel> datas = [];
  FavoriteBloc():super(const FavoriteState())
  {
      db=DB();
      on<AddFavorites>(_mapAddFavorite);
      on<RemoveFavorites>(_mapRemove);
      on<GetFavorites>(_getDb);
     add(GetFavorites());
  }

    void _mapAddFavorite(AddFavorites event,Emitter<FavoriteState> emit)async{
      event.musicModel.isFavorite=true;
    final state=this.state;
    // emit(FavoriteState(music: List.from(state.music)..add(event.musicModel),));
      db.insertData(event.musicModel);
      datas = await db.getData();
      emit(state.copyWith(datas));
    }
  void _mapRemove(RemoveFavorites event,Emitter<FavoriteState> emit)async{
    event.musicModel.isFavorite=false;
    await db.delete(event.musicModel.id);
    datas = await db.getData();
    final state=this.state;
    // emit(FavoriteState(music: List.from(state.music)..remove(event.musicModel),));
    emit(state.copyWith(datas));

  }

  FutureOr<void> _getDb(GetFavorites event, Emitter<FavoriteState> emit) async {
    datas = await db.getData();
  }
}
