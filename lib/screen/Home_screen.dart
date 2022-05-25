import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/detail_page.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<MusicModel> _list;
  late int _playId;

  @override
  void initState() {
    _playId = 3;
    _list = MusicModel.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Music",
          style: TextStyle(
              color: AppColors.styleColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    customButtonWidget(
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.styleColor,
                      ),
                      size: 50,
                      onTap: (){},
                    ),
                    customButtonWidget(
                      image: "assets/logo.jpg",
                      size: 150,
                      borderwidth: 5,
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DetailPage()));
                      },
                    ),
                    customButtonWidget(
                      child: Icon(
                        Icons.menu,
                        color: AppColors.styleColor,
                      ),
                      size: 50,
                      onTap: (){},
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _list.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DetailPage()));},
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                              color: _list[index].id == _playId ?AppColors.activeColor:AppColors.mainColor,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _list[index].title,
                                      style: TextStyle(
                                        color: AppColors.styleColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _list[index].album,
                                      style: TextStyle(
                                        color: AppColors.styleColor.withAlpha(90),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                customButtonWidget(
                                  child: Icon(
                                    _list[index].id == _playId ? Icons.pause:Icons.play_arrow,
                                    color: _list[index].id == _playId
                                        ? Colors.white
                                        : AppColors.styleColor,
                                  ),
                                  size: 50,
                                  onTap: (){
                                    setState((){
                                      _playId=_list[index].id;
                                    });
                                  },
                                  isActive: _list[index].id == _playId,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mainColor.withAlpha(0),
                      AppColors.mainColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
