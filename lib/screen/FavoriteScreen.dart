import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: ListView.builder(
        itemBuilder: (context,index)=>ListTile(
          leading: ImageMusicShow(size: 60,imageOfMusic: datas[index].artworkWidget,),
          title: Text(datas[index].title.toString()),
          subtitle: Text(datas[index].artist.toString()),
          trailing: IconButton(onPressed: (){db.delete(datas[index].id);}, icon: Icon(Icons.delete)),
        ),
        itemCount: datas.length,
      )

    );
  }
}
