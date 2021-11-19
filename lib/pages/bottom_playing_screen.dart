import 'package:Musify/databases/box_instance.dart';
import 'package:Musify/databases/songs_adapter.dart';
import 'package:Musify/pages/playing_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

class bottomPlating extends StatefulWidget {
  const bottomPlating({
    required this.audio,
    Key? key,
  }) : super(key: key);

  final List<Audio> audio;

  @override
  _bottomPlayingState createState() => _bottomPlayingState();
}

class _bottomPlayingState extends State<bottomPlating> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool nextDone = true;
  bool prevDone = true;
  Audio? myAudio;

  Box _box = Boxes.getInstance();
  find(List<Audio> source, String fromPath) {
    if (source.length != 0)
      myAudio = source.firstWhere((element) => element.path == fromPath);

    List<Songs> song = _box.get("tracks");
    final temp = song.firstWhere(
      (element) => element.id.toString().contains(myAudio!.metas.id.toString()),
    );
    List<dynamic> recentsong = [];
    recentsong.add(temp);
    _box.put("recentsong", recentsong);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff4D3C3C),
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
              widget.audio,
              playing!.audio.assetAudioPath,
            );
            return myAudio != null
                ? ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicView(audio: widget.audio),
                        ),
                      );
                    },
                    leading: QueryArtworkWidget(
                      id: int.parse(myAudio!.metas.id!),
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
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
                              nextDone = true;
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Container(
                          height: 37,
                          width: 37,
                          margin: EdgeInsets.only(top: 5),
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
                                        icon: Icon(
                                          Icons.pause,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () {
                                          _assetsAudioPlayer.playOrPause();
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 20,
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
                          icon: Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox();
          },
        ),
      ),
    );
  }
}
