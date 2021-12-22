import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:Mussy/pages/playing_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class BottomPlaying extends StatelessWidget {
  BottomPlaying({
    Key? key,
  }) : super(key: key);
  final _player = Player();
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final songController = Get.find<SongController>();
  bool nextDone = true;
  bool prevDone = true;
  Audio? myAudio;

  final Box _box = Boxes.getInstance();
  find(List<Audio> source, String fromPath) {
    if (source.isNotEmpty) {
      myAudio = source.firstWhere((element) => element.path == fromPath);
      if (myAudio != null) {
        List<Songs> songs = _box.get("tracks");
        final temp =
            _player.findSongFromDatabase(songs, myAudio!.metas.id.toString());
        List<Songs> recentsong = [];
        recentsong.add(temp);
        _box.put("recentsong", recentsong);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xff3a2d2d),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        margin: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: _assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing? playing) {
            find(
              songController.songModels,
              playing!.audio.assetAudioPath,
            );
            return myAudio != null
                ? GetBuilder<SongController>(
                    id: "bottom",
                    builder: (_controller) {
                      return ListTile(
                        onTap: () {
                          Get.to(() =>
                              MusicView(audio: _controller.songModels));
                        },
                        leading: QueryArtworkWidget(
                          id: int.parse(myAudio!.metas.id!),
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: const Image(
                              height: 50,
                              image: AssetImage("assets/icons/default.jpg"),
                            ),
                          ),
                        ),
                        title: Text(
                          myAudio!.metas.title!,
                          style: GoogleFonts.rubik(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          myAudio!.metas.artist!,
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (prevDone) {
                                  prevDone = false;
                                  await _assetsAudioPlayer.previous();
                                  prevDone = true;
                                }
                              },
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            Container(
                              height: 37,
                              width: 37,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              child: _assetsAudioPlayer.builderIsPlaying(
                                builder: (context, isPlaying) {
                                  return isPlaying
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            onPressed: () {
                                              _assetsAudioPlayer.playOrPause();
                                            },
                                            icon: const Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            onPressed: () {
                                              _assetsAudioPlayer.playOrPause();
                                            },
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (nextDone) {
                                  nextDone = false;
                                  await _assetsAudioPlayer.next();
                                  nextDone = true;
                                }
                              },
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}
