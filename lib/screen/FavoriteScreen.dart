import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/Widget/list_song_favorite.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/image_music_shower.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late DB db;
  List<MusicModel> datas=[];
  @override
  void initState() {
    super.initState();
    db=DB();
   getData2();
  }
  void getData2() async{
    datas=await db.getData();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: [
          BlocBuilder<BlocMusic,BlocState>(builder: (context,state){
            return Expanded(child: ListOfSongFavorite(currentPlayMusic: state.favorites));
          }),
        ],
      )
  );}
}