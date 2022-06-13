import 'package:app_music_bkav/Bloc_favorites/Favorite_Bloc.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorite_Even.dart';
import 'package:app_music_bkav/Bloc_favorites/Favorites_state.dart';
import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/Widget/image_music_shower.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:audioplayers/audioplayers_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_provider.dart';

class FavoriteScreen extends StatefulWidget {
  final MusicModel? currentPlayMusic;
  const FavoriteScreen({Key? key, this.currentPlayMusic}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int _id = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bloc1 = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Favorites',
          style: TextStyle(
              color: AppColors.styleColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      // body: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
      //   return ListView.builder(
      //       itemCount: state.music.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //             title: Text('${state.music[index].title}'),
      //             trailing: IconButton(
      //               onPressed: () {
      //                 BlocProvider.of<FavoriteBloc>(context)
      //                     .add(RemoveFavorites(state.music[index]));
      //               },
      //               icon: Icon(Icons.delete),
      //             ),
      //             leading: ImageMusicShow(
      //               imageOfMusic: state.music[index].artworkWidget,
      //               size: 50,
      //             ),
      //             subtitle: Text('${state.music[index].artist}'),
      //             onTap: () {
      //               if (bloc.audioPlayer.state != PlayerState.PLAYING) {
      //                 bloc.add(PlayMusic(state.music[index].id));
      //
      //                 setState(() {
      //                   _id = state.music[index].id;
      //                 });
      //               } else if (bloc.audioPlayer.state == PlayerState.PLAYING &&
      //                   widget.currentPlayMusic != state.music[index]) {
      //                 bloc.add(PlayMusic(state.music[index].id));
      //                 setState(() {
      //                   _id = state.music[index].id;
      //                 });
      //               };
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(builder: (c) {
      //                   bloc.add(SetValue(state.music[index]));
      //                   return DetailPage(
      //                     model: state.music[index],
      //                     newModel: state.music[index],
      //                   );
      //                 }),
      //               );
      //               setState((){});
      //             });
      //       });
      // }),

      body: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            leading: ImageMusicShow(
              imageOfMusic: bloc1.datas[index].artworkWidget,
              size: 50,
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(bloc1.datas[index].title),
            subtitle: Text(bloc1.datas[index].artist),
            trailing: IconButton(
                icon: bloc.musics[index].isFavorite
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border),
                onPressed: () async {
                  setState(() {
                    BlocProvider.of<FavoriteBloc>(context)
                        .add(RemoveFavorites(bloc.musics[index]));
                  });
                }),
            onTap: () {
              if (bloc.audioPlayer.state != PlayerState.PLAYING) {
                bloc.add(PlayMusic(bloc1.datas[index].id));

                setState(() {
                  _id = bloc1.datas[index].id;
                });
              } else if (bloc.audioPlayer.state == PlayerState.PLAYING &&
                  widget.currentPlayMusic != bloc1.datas[index]) {
                bloc.add(PlayMusic(bloc1.datas[index].id));
                setState(() {
                  _id = bloc1.datas[index].id;
                });
              }
              ;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) {
                  bloc.add(SetValue(bloc1.datas[index]));
                  return DetailPage(
                    model: bloc1.datas[index],
                    newModel: bloc1.datas[index],
                  );
                }),
              );
              setState(() {});
            },
          ),
          itemCount: bloc1.datas.length,
        );
      }),
    );
  }
}
