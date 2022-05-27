import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/Widget/list_song.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: ListView.builder(
        itemBuilder: (context,index)=>ListTile(
          leading: CircleAvatar(),
          title: Text(datas[index].title),
          subtitle: Text(datas[index].artist),

        ),
        itemCount: datas.length,
      )
    );
  }
}
