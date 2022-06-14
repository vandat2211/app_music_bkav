import 'dart:async';
import 'package:app_music_bkav/Bloc_Search/Search_Bloc.dart';
import 'package:app_music_bkav/Bloc_Search/Search_Event.dart';
import 'package:app_music_bkav/Bloc_Search/Search_State.dart';
import 'package:app_music_bkav/Bloc_music/Music_Bloc.dart';
import 'package:app_music_bkav/Bloc_music/Music_State.dart';
import 'package:app_music_bkav/Database.dart';


import 'package:app_music_bkav/Widget/list_button.dart';
import 'package:app_music_bkav/Widget/list_song_search.dart';
import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widget/Image_music_shower.dart';

class SearchScreen extends StatefulWidget {
  final List<MusicModel> musics;
  const SearchScreen({Key? key, required this.musics}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isFavorit = false;
  final controller = TextEditingController();

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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SongSearch(
                      searchBloc: BlocProvider.of<SearchBloc>(context)),
                );
              },
              icon: Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Music",
          style: TextStyle(
              color: AppColors.styleColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
        setState() {
          final MusicModel _music = state.musicModel;
        }

        return Column(
          children: <Widget>[
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

class SongSearch extends SearchDelegate<List> {
  SearchBloc searchBloc;
  SongSearch({required this.searchBloc});
  late String querystring;
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
    querystring = query;
    searchBloc.add(SearchEventLoadData(query: query));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
      if (state is SearchUninitialized) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is SearchError) {
        return Center(
          child: Text('Failed'),
        );
      }
      if (state is SearchLoad) {
        if (state.song.isEmpty) {
          return Center(
            child: Text('No results'),
          );
        }
        return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: ImageMusicShow(
                  imageOfMusic: state.song[index].artworkWidget,
                  size: 50,
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(state.song[index].title),
                subtitle: Text(state.song[index].artist),
              );
            },
            itemCount: state.song.length);
      }
      return Scaffold();
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
