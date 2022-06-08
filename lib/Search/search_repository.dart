import 'package:app_music_bkav/Model/music_model.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:on_audio_query/on_audio_query.dart';
abstract class SearchRepository{

  Future<List<MusicModel>> getSong(String query);
}
class SearchRepositoryImpl extends SearchRepository{
  @override
  Future<List<MusicModel>> getSong(String query) async{
    Audiotagger audiotagger = Audiotagger();
    final List<MusicModel> musics = [];
    late OnAudioQuery onAudioQuery=OnAudioQuery();
    final songs = await onAudioQuery.querySongs();
    for (var element in songs) {
      if (element.duration != null && element.duration != 0) {
        final artWork = await audiotagger.readArtwork(path: element.data);
        final music = MusicModel(
            artist: element.artist!,
            id: element.id,
            path: element.data,
            title: element.title,
            duration: element.duration!,
            artworkWidget:artWork);
        musics.add(music);
        await Future.delayed(
            const Duration(milliseconds: 10)); // this is for complete ui
      }
    }
    throw UnimplementedError();
  }

}