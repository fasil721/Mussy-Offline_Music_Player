import 'package:Mussy/databases/songs_adapter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Player {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  openPlayer(int index, List<Audio> audios) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notify = prefs.getBool("notify");
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: index),
      showNotification: notify == null || notify == true ? true : false,
      autoStart: true,
      playInBackground: PlayInBackground.enabled,
      loopMode: LoopMode.playlist,
      notificationSettings: const NotificationSettings(stopEnabled: false),
    );
  }

  List<Audio> convertToAudios(List<dynamic> songs) {
    List<Audio> audios = [];
    for (var element in songs) {
      audios.add(
        Audio.file(
          element.uri.toString(),
          metas: Metas(
            title: element.title,
            artist: element.artist,
            id: element.id.toString(),
          ),
        ),
      );
    }
    return audios;
  }

  Songs findSongFromDatabase(List<dynamic> songs, String id) {
    return songs.firstWhere(
      (element) => element.id.toString().contains(id),
    );
  }
}
