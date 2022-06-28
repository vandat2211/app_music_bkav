import 'dart:async';
import 'package:app_music_bkav/database/database.dart';

import 'package:app_music_bkav/Widget/button_playmedia.dart';
import 'package:app_music_bkav/Widget/list_songs.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/screen/musicplayerscreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc_music/music_bloc.dart';
import '../bloc_music/music_event.dart';
import '../bloc_music/music_state.dart';
import '../widget/image_music_shower.dart';

class SearchScreen extends StatefulWidget {
  final List<MusicModel> musics;
  const SearchScreen({Key? key, required this.musics}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isFavorit = false;
  final controller = TextEditingController();
  List<MusicModel> listmusic = [];
  @override
  void initState() {
    super.initState();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bool isEmptyMusics = bloc.musics.first.path.isEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {

        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: TextField(
                onTap:(){ showSearch(context: context,delegate: SongSearch(list: bloc.musics,currentPlayMusic: state.musicModel));},
                // onChanged: SearchView,
                controller: controller,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blueAccent))),
              ),
            ),
            Expanded(
              child: ListOfSongSearch(currentPlayMusic: state.musicModel),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListButton(
                    currentPlayMusic: state.musicModel,
                    newModel: state.musicModel,
                  )),
            )
          ],
        );
      }),
    );
  }
}

class SongSearch extends SearchDelegate<MusicModel> {
  final MusicModel? currentPlayMusic;
  late final List<MusicModel> list;
  SongSearch({required this.list,this.currentPlayMusic});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final suggestionList =
        bloc.musics.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageMusicShow(
                imageOfMusic: suggestionList[index].artworkWidget,
                size: 50,
                borderRadius: BorderRadius.circular(10)),
            title: Text(suggestionList[index].title),
            subtitle: Text("${suggestionList[index].artist}"),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final suggestionList =
        bloc.musics.where((element) => element.title.contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: ImageMusicShow(
              imageOfMusic: suggestionList[index].artworkWidget,
              size: 50,
              borderRadius: BorderRadius.circular(10)),
          title: Text("${suggestionList[index].title}"),
          subtitle: Text("${suggestionList[index].artist}"),
          onTap: (){
        if (bloc.audioPlayer.state != PlayerState.PLAYING) {
        bloc.add(PlayMusic(suggestionList[index].id));
        }
        else if (bloc.audioPlayer.state == PlayerState.PLAYING &&
             currentPlayMusic!= suggestionList[index]) {
          bloc.add(PlayMusic(suggestionList[index].id));
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (c) {
            bloc.add(SetValue(suggestionList[index]));
            return DetailPage(
              model: suggestionList[index],
              newModel: suggestionList[index],
            );
          }),
        );

        },
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
