import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorites_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body:BlocBuilder<FavoriteBloc,FavoriteState>(
        builder: (context,state){
          if(state is FavoriteLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          };
          if(state is FavoriteLoaded){
            return ListView.builder(itemCount: state.favorite.music.length,itemBuilder: (context,index){
              return ListTile(title: Text(state.favorite.music[index].title),);
            });
          }
          else return Text('ok');
        },
      ),
    );
  }
}
