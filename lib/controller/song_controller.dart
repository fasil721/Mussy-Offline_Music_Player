import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  @override
  void onInit() {
    requesrpermisson();
    super.onInit();
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  int currentIndex = 0;
  final box = Boxes.getInstance();
  final _player = Player();
  List<SongModel> tracks = [];
  List<SongModel> musics = [];
  List<Songs> audio = [];
  List<Audio> songModels = [];
  requesrpermisson() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    tracks = await _audioQuery.querySongs();

    for (var element in tracks) {
      if (element.fileExtension == "mp3" || element.fileExtension == "opus") {
        musics.add(element);
      }
    }
    audio = musics
        .map(
          (e) => Songs(
            title: e.title,
            artist: e.artist,
            uri: e.uri,
            id: e.id,
            duration: e.duration,
          ),
        )
        .toList();
    songModels = _player.convertToAudios(musics);
    await box.put("tracks", audio);
    update(["home", "navbar"]);
  }
}

class SongBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SongController());
  }
}
