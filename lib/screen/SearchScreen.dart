import 'dart:async';
import 'dart:typed_data';

import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Widget/list_button.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widget/image_music_shower.dart';
import '../Widget/list_song.dart';

class SearchScreen extends StatefulWidget {
  final List<MusicModel> musics;
  const SearchScreen({Key? key, required this.musics}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isFavorit = false;
  bool isMuteVolume = false;
  late Timer whenStartTimer;
  List<MusicModel> _song = [];
  List<MusicModel> _songlist = <MusicModel>[];
  String id = "";
  double changeVolume = 0;
  late DB db;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = DB();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bool isEmptyMusics = bloc.musics.first.path.isEmpty;
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
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
        setState() {
          final MusicModel _music = state.musicModel;
        }

        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search songs',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue)
                        )
                    ),
                    onChanged: SearchSong,
                  ),
                ),
                Expanded(
                  child: isEmptyMusics
                      ? _notFoundMusic()
                      : ListOfSongSearch(currentPlayMusic: state.musicModel),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListButton(currentPlayMusic: state.musicModel,
                        newModel: state.musicModel,)
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _notFoundMusic() {
    return Scaffold(
      body: Center(
        child: Text(
          "Not Found Music",
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.styleColor),
        ),
      ),
    );
  }

  void SearchSong(String query) {
  }
}
