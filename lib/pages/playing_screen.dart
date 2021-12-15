import 'package:Mussy/controller/song_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:Mussy/widgets/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MusicView extends StatefulWidget {
  const MusicView({
    required this.audio,
    Key? key,
  }) : super(key: key);

  final List<Audio> audio;

  @override
  _MusicViewState createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool isLooping = false;
  String repeatIcon = "assets/icons/repeat.png";
  final songController = Get.find<SongController>();
  final _box = Boxes.getInstance();
  final _player = Player();
  bool nextDone = true;
  bool prevDone = true;
  Songs? music;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  find2(Audio myAudio) {
    List<Songs> songs = _box.get("tracks");
    music = _player.findSongFromDatabase(songs, myAudio.metas.id.toString());
  }

  Widget popupMenu() {
    return PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        const PopupMenuItem(
          child: Text("Add to playlist"),
          value: "1",
        ),
      ],
      onSelected: (value) {
        if (value == "1") {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddToPlaylist(song: music),
          );
        }
      },
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Colors.black],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 0.5),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                height: 25,
                image: AssetImage("assets/icons/arrow.png"),
              ),
            ),
          ),
          actions: [
            popupMenu(),
            const SizedBox(
              width: 15,
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
        ),
        body: _assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing? playing) {
            final myAudio = find(
              widget.audio,
              playing!.audio.assetAudioPath,
            );
            find2(myAudio);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Center(
                    child: QueryArtworkWidget(
                      artworkHeight: 300,
                      artworkWidth: 300,
                      id: int.parse(myAudio.metas.id!),
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: const Image(
                          height: 300,
                          image: AssetImage("assets/icons/default.jpg"),
                        ),
                      ),
                      type: ArtworkType.AUDIO,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 85,
                    padding: const EdgeInsets.only(
                      left: 23,
                      right: 15,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      title: Text(
                        myAudio.metas.title!,
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          myAudio.metas.artist!,
                          maxLines: 1,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      trailing: GetBuilder<SongController>(
                        id: "favbtn",
                        builder: (_) {
                          List favourites = _box.get("favourites");
                          return favourites
                                  .where((element) =>
                                      element.id.toString() ==
                                      myAudio.metas.id.toString())
                                  .isEmpty
                              ? IconButton(
                                  onPressed: () async {
                                    favourites.add(music);
                                    await _box.put("favourites", favourites);
                                    songController.update(["favbtn", "favs"]);
                                  },
                                  icon: const Image(
                                    height: 25,
                                    image: AssetImage("assets/icons/heart.png"),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    favourites.removeWhere((element) =>
                                        element.id.toString() ==
                                        myAudio.metas.id.toString());
                                    await _box.put("favourites", favourites);
                                    songController.update(["favbtn", "favs"]);
                                  },
                                  icon: const Image(
                                    height: 25,
                                    image: AssetImage(
                                        "assets/icons/heartfill.png"),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(
                    right: 40,
                    left: 40,
                  ),
                  child: _assetsAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, RealtimePlayingInfos? infos) {
                      if (infos == null) {
                        return const SizedBox();
                      }
                      return ProgressBar(
                        timeLabelPadding: 8,
                        progressBarColor: Colors.white,
                        thumbColor: Colors.white,
                        baseBarColor: Colors.grey,
                        progress: infos.currentPosition,
                        total: Duration(milliseconds: music!.duration!),
                        timeLabelTextStyle:
                            const TextStyle(color: Colors.white),
                        onSeek: (duration) {
                          _assetsAudioPlayer.seek(duration);
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: GetBuilder<SongController>(
                                id: "shuffle",
                                builder: (_) {
                                  return _assetsAudioPlayer.isShuffling.value
                                      ? IconButton(
                                          onPressed: () {
                                            _assetsAudioPlayer.toggleShuffle();
                                            songController.update(["shuffle"]);
                                          },
                                          icon: const Image(
                                            height: 25,
                                            image: AssetImage(
                                                "assets/icons/shuffling.png"),
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            _assetsAudioPlayer.toggleShuffle();
                                            songController.update(["shuffle"]);
                                          },
                                          icon: const Image(
                                            height: 25,
                                            image: AssetImage(
                                                "assets/icons/ishuffle.png"),
                                          ),
                                        );
                                }),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                if (prevDone) {
                                  prevDone = false;
                                  await _assetsAudioPlayer.previous();
                                  prevDone = true;
                                }
                              },
                              icon: const Image(
                                image: AssetImage("assets/icons/start.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _assetsAudioPlayer.builderIsPlaying(
                              builder: (context, isPlaying) {
                                return isPlaying
                                    ? IconButton(
                                        iconSize: 40,
                                        onPressed: () {
                                          _assetsAudioPlayer.playOrPause();
                                        },
                                        icon: const Image(
                                          height: 50,
                                          image: AssetImage(
                                              "assets/icons/pause.png"),
                                        ),
                                      )
                                    : IconButton(
                                        iconSize: 40,
                                        onPressed: () {
                                          _assetsAudioPlayer.playOrPause();
                                        },
                                        icon: const Image(
                                          height: 50,
                                          image: AssetImage(
                                              "assets/icons/play.png"),
                                        ),
                                      );
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                if (nextDone) {
                                  nextDone = false;
                                  await _assetsAudioPlayer.next();
                                  nextDone = true;
                                }
                              },
                              icon: const Image(
                                image: AssetImage("assets/icons/end.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GetBuilder<SongController>(
                                id: "repeat",
                                builder: (context) {
                                  return IconButton(
                                    onPressed: () {
                                      if (!isLooping) {
                                        isLooping = true;
                                        _assetsAudioPlayer
                                            .setLoopMode(LoopMode.single);
                                        repeatIcon = "assets/icons/repeat1.png";
                                        songController.update(["repeat"]);
                                      } else {
                                        isLooping = false;
                                        _assetsAudioPlayer
                                            .setLoopMode(LoopMode.playlist);
                                        repeatIcon = "assets/icons/repeat.png";
                                        songController.update(["repeat"]);
                                      }
                                    },
                                    icon: Image(
                                      height: 25,
                                      image: AssetImage(repeatIcon),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
