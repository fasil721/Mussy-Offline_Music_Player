import 'package:Musify/databases/box.dart';
import 'package:Musify/databases/songs_adapter.dart';
import 'package:Musify/widgets/add_to_playlist.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
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
  Box _box = Boxes.getInstance();
  bool nextDone = true;
  bool prevDone = true;
  Songs? music;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  find2(Audio myAudio) {
    List<Songs> song = _box.get("tracks");
    music = song.firstWhere(
      (element) => element.id.toString().contains(myAudio.metas.id.toString()),
    );
  }

  Widget popupMenu() {
    return PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(
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
      icon: Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image(
              height: 25,
              image: AssetImage("assets/icons/arrow.png"),
            ),
          ),
        ),
        actions: [
          popupMenu(),
          SizedBox(
            width: 15,
          )
        ],
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
      ),
      backgroundColor: Colors.black,
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
                flex: 4,
                child: Center(
                  child: QueryArtworkWidget(
                    artworkHeight: 300,
                    artworkWidth: 300,
                    id: int.parse(myAudio.metas.id!),
                    nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        height: 300,
                        image: AssetImage("assets/icons/default.jpg"),
                      ),
                    ),
                    type: ArtworkType.AUDIO,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 23,
                    right: 15,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
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
                    trailing: Favourites(music: music!, myAudio: myAudio),
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
                      return SizedBox();
                    }
                    return ProgressBar(
                      timeLabelPadding: 8,
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      baseBarColor: Colors.grey,
                      progress: infos.currentPosition,
                      total: infos.duration,
                      timeLabelTextStyle: TextStyle(color: Colors.white),
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
                          child: Shuffle(),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              if (prevDone) {
                                prevDone = false;
                                await _assetsAudioPlayer.previous();
                                nextDone = true;
                              }
                            },
                            icon: Image(
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
                                      icon: Image(
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
                                      icon: Image(
                                        height: 50,
                                        image:
                                            AssetImage("assets/icons/play.png"),
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
                            icon: Image(
                              image: AssetImage("assets/icons/end.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Repeat(),
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
    );
  }
}

class Favourites extends StatefulWidget {
  const Favourites({Key? key, required this.music, required this.myAudio})
      : super(key: key);
  final Songs music;
  final Audio myAudio;
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  Box _box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    List<dynamic> favorites = _box.get("favorites");

    return favorites
            .where((element) =>
                element.id.toString() == widget.myAudio.metas.id.toString())
            .isEmpty
        ? IconButton(
            onPressed: () async {
              favorites.add(widget.music);
              await _box.put("favorites", favorites);
              setState(() {});
            },
            icon: Image(
              height: 25,
              image: AssetImage("assets/icons/heart.png"),
            ),
          )
        : IconButton(
            onPressed: () async {
              favorites.removeWhere((element) =>
                  element.id.toString() == widget.music.id.toString());
              await _box.put("favorites", favorites);
              setState(() {});
            },
            icon: Image(
              height: 25,
              image: AssetImage("assets/icons/heartfill.png"),
            ),
          );
  }
}

class Shuffle extends StatefulWidget {
  const Shuffle({Key? key}) : super(key: key);

  @override
  _ShuffleState createState() => _ShuffleState();
}

class _ShuffleState extends State<Shuffle> {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  @override
  Widget build(BuildContext context) {
    return _assetsAudioPlayer.isShuffling.value
        ? IconButton(
            onPressed: () {
              setState(() {
                _assetsAudioPlayer.toggleShuffle();
              });
            },
            icon: Image(
              height: 25,
              image: AssetImage("assets/icons/shuffling.png"),
            ),
          )
        : IconButton(
            onPressed: () {
              setState(() {
                _assetsAudioPlayer.toggleShuffle();
              });
            },
            icon: Image(
              height: 25,
              image: AssetImage("assets/icons/ishuffle.png"),
            ),
          );
  }
}

class Repeat extends StatefulWidget {
  const Repeat({Key? key}) : super(key: key);

  @override
  _RepeatState createState() => _RepeatState();
}

class _RepeatState extends State<Repeat> {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool isLooping = false;
  String repeatIcon = "assets/icons/repeat.png";
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isLooping) {
          setState(() {
            isLooping = true;
            _assetsAudioPlayer.setLoopMode(LoopMode.single);
            repeatIcon = "assets/icons/repeat1.png";
          });
        } else {
          setState(() {
            isLooping = false;
            _assetsAudioPlayer.setLoopMode(LoopMode.playlist);
            repeatIcon = "assets/icons/repeat.png";
          });
        }
      },
      icon: Image(
        height: 25,
        image: AssetImage(repeatIcon),
      ),
    );
  }
}
