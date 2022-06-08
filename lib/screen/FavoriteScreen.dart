import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorites_state.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Widget/image_music_shower.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('FavoriteSong',style: TextStyle(
            color: AppColors.styleColor, fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.mainColor,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: AppColors.styleColor,)),
      ),
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
        return ListView.builder(
            itemCount: state.music.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${state.music[index].title}'),
                trailing: IconButton(
                  onPressed: () {
                    BlocProvider.of<FavoriteBloc>(context)
                        .add(RemoveFavorites(state.music[index]));
                  },
                  icon: Icon(Icons.delete),
                ),
                leading: ImageMusicShow(
                  imageOfMusic: state.music[index].artworkWidget,
                  size: 50,
                ),
                subtitle: Text('${state.music[index].artist}'),
                onTap: () {},
              );
            });
      }),
    );
  }
}
