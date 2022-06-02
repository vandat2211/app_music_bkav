import 'dart:typed_data';

import 'package:app_music_bkav/Database.dart';
import 'package:app_music_bkav/Model/music_model.dart';
import 'package:app_music_bkav/bloc/bloc_event.dart';
import 'package:app_music_bkav/bloc/bloc_provider.dart';
import 'package:app_music_bkav/bloc/bloc_state.dart';
import 'package:app_music_bkav/screen/detail_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resource/Color_manager.dart';
import 'custom_button_widge.dart';
class ListOfSongFavorite extends StatefulWidget {
  final List<MusicModel>? currentPlayMusic;
  const ListOfSongFavorite({Key? key,this.currentPlayMusic}) : super(key: key);

  @override
  State<ListOfSongFavorite> createState() => _ListOfSongFavoriteState();
}

class _ListOfSongFavoriteState extends State<ListOfSongFavorite> with SingleTickerProviderStateMixin{
  int _id = 0;
  late AnimationController _controller;
  late DB db;
  @override
  void initState() {
    super.initState();
    db = DB();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.musics.length,
        itemBuilder: (ctx, index) {
          final MusicModel _muicIndex = bloc.musics[index];
          return BlocListener<BlocMusic, BlocState>(
            bloc: bloc,
            listener: (context, state) {
              if (bloc.audioPlayer.state == PlayerState.PLAYING) {
                _id = state.musicModel.id;
                _controller.forward();
              } else {
                Future.delayed(const Duration(milliseconds: 400)).then((value) {
                  setState(() {
                    _id = 0;
                  });
                });
                _controller.reverse();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: _id == _muicIndex.id
                      ? AppColors.activeColor
                      : AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (c) {
                  //       bloc.add(
                  //         SetValue(bloc.musics[index]),
                  //       );
                  //       return DetailPage(
                  //         model: widget.currentPlayMusic!,
                  //         newModel: _muicIndex,
                  //       );
                  //     },
                  //   ),
                  // ).then((value) {
                  //   setState(() {
                  //     if (bloc.audioPlayer.state == PlayerState.PLAYING) {
                  //       _id = widget.currentPlayMusic!.id;
                  //       _controller.forward();
                  //     } else {
                  //       _controller.reverse();
                  //       _id = 0;
                  //     }
                  //   });
                  // });
                  if (bloc.audioPlayer.state != PlayerState.PLAYING) {
                    bloc.add(PlayMusic(_muicIndex.id));

                    _controller.forward();
                    setState(() {
                      _id = _muicIndex.id;
                    });
                  } else if (bloc.audioPlayer.state ==
                      PlayerState.PLAYING &&
                      widget.currentPlayMusic![index] != _muicIndex) {
                    bloc.add(PlayMusic(_muicIndex.id));
                    _controller.forward();
                    setState(() {
                      _id = _muicIndex.id;
                    });
                  // } else {
                  //   _controller.reverse();
                  //   bloc.add(PauseResumeMusic());
                  //   Future.delayed(_controller.duration!)
                  //       .then((value) {
                  //     setState(() {
                  //       _id = 0;
                  //     });
                  //   });
                  // }
                }},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _muicIndex.title.length < 50
                              ? _muicIndex.title
                              : _muicIndex.title.substring(50),
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight : FontWeight.w600,
                              color:AppColors.styleColor,
                          ),
                        ),
                        Text(
                          _muicIndex.artist,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight : FontWeight.w400,
                              color:AppColors.styleColor
                          ),
                        ),
                      ],
                    ),
                    customButtonWidget(
                      isActive: _id == _muicIndex.id,
                      child: IconButton(
                          icon: _id == _muicIndex.id
                              ? AnimatedIcon(
                            progress: _controller,
                            icon: AnimatedIcons.play_pause,
                            color: _id == widget.currentPlayMusic![index].id
                                ? Colors.white
                                : AppColors.styleColor,
                          )
                              : const Icon(Icons.play_arrow),
                          onPressed: () async {
                            // change with event
                            // if (bloc.audioPlayer.state != PlayerState.PLAYING) {
                            //   bloc.add(PlayMusic(_muicIndex.id));
                            //
                            //   _controller.forward();
                            //   setState(() {
                            //     _id = _muicIndex.id;
                            //   });
                            // } else if (bloc.audioPlayer.state ==
                            //     PlayerState.PLAYING &&
                            //     widget.currentPlayMusic != _muicIndex) {
                            //   bloc.add(PlayMusic(_muicIndex.id));
                            //   _controller.forward();
                            //   setState(() {
                            //     _id = _muicIndex.id;
                            //   });
                            // } else {
                            //   _controller.reverse();
                            //   bloc.add(PauseResumeMusic());
                            //   Future.delayed(_controller.duration!)
                            //       .then((value) {
                            //     setState(() {
                            //       _id = 0;
                            //     });
                            //   });
                            // }
                            // db.insertData(MusicModel(artworkWidget: _muicIndex.artworkWidget, artist: _muicIndex.artist, id: _muicIndex.id, path: _muicIndex.path, title: _muicIndex.title, duration: _muicIndex.duration));
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
