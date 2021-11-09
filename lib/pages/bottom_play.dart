import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/databases/songs_adapter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class bottomPlating extends StatefulWidget {
  const bottomPlating({
    required this.audio,
    Key? key,
  }) : super(key: key);
  final List<Songs> audio;

  @override
  _bottomPlatingState createState() => _bottomPlatingState();
}

class _bottomPlatingState extends State<bottomPlating> {
  dynamic currentTitle = "";
  dynamic currentArtist = "";
  int currentCover = 0;
  dynamic currentSong = "";
  IconData btnIcon = Icons.play_arrow;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  Songs find(List<Songs> source, String fromPath) {
    return source.firstWhere((element) => element.uri == fromPath);
  }

  var isplaying = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
        ),
        color: Colors.blue,
        child: _assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing? playing) {
            final myAudio = find(widget.audio, playing!.audio.assetAudioPath);

            return ListTile(
              leading: QueryArtworkWidget(
                id: myAudio.id,
                type: ArtworkType.AUDIO,
              ),
              title: Text(myAudio.title),
              subtitle: Text(myAudio.artist),
              trailing: Container(
                height: 40.0,
                width: 40.0,
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    // _assetsAudioPlayer.playOrPause();
                    if (_assetsAudioPlayer.isPlaying.value) {
                      setState(() {
                        isplaying = false;
                        _assetsAudioPlayer.pause();
                      });
                    } else {
                      setState(() {
                        isplaying = true;
                        _assetsAudioPlayer.play();
                      });
                    }
                    // var a=PlayerBuilder.isPlaying(
                    //   player: _assetsAudioPlayer,
                    //   builder: (context, isPlaying) {
                    //     print(isPlaying);
                    //     if (isPlaying) {

                    //       setState(() {
                    //         isPlaying = false;
                    //       });
                    //     }
                    //     return Icon(Icons.play_arrow);
                    //   },
                    // );

                    // if (Playing == true) {
                    //   setState(() {
                    //     Playing == false;
                    //     btnIcon = Icons.pause;
                    //   });
                    // } else {
                    //   _assetsAudioPlayer.play();
                    //   setState(() {
                    //     Playing == false;
                    //     btnIcon = Icons.play_arrow;
                    //   });
                    // }
                  },
                  icon: Icon(
                    isplaying ? Icons.pause : Icons.play_arrow,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
