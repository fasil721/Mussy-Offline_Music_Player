import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/databases/songs_adapter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class bottomPlating extends StatefulWidget {
  // const bottomPlating({
  //   required this.audio,
  //   Key? key,
  // }) : super(key: key);
  // final List<Songs> audio;

  @override
  _bottomPlatingState createState() => _bottomPlatingState();
}

class _bottomPlatingState extends State<bottomPlating> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  Songs find(List<Songs> source, String fromPath) {
    return source.firstWhere((element) => element.uri == fromPath);
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    getsongs();
    super.initState();
  }

  List<SongModel> tracks1 = [];
  List<Songs> audio1 = [];

  getsongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (permissionStatus) {
      tracks1 = await _audioQuery.querySongs();
      audio1 = tracks1
          .map(
            (e) => Songs(
              title: e.title,
              artist: e.artist,
              uri: e.uri,
              duration: e.duration,
              id: e.id,
            ),
          )
          .toList();
      setState(() {});
    }
  }

  var btnIcn = Icons.pause;
  bool isplaying = true;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: _assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing? playing) {
            final myAudio = find(audio1, playing!.audio.assetAudioPath);

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
                child: _assetsAudioPlayer.builderIsPlaying(
                  builder: (context, isPlaying) {
                    return (isPlaying
                        ? IconButton(
                            onPressed: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.pause,
                              size: 23,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              size: 23,
                            ),
                          ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
