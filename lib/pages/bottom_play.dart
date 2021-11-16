import 'package:Musify/pages/playing_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff4D3C3C),
          //  Color(0xff414345),
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
            final myAudio = find(
              widget.audio,
              playing!.audio.assetAudioPath,
            );
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicView(audio: widget.audio),
                  ),
                );
              },
              leading: QueryArtworkWidget(
                id: int.parse(myAudio.metas.id!),
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
                myAudio.metas.title!,
                style: GoogleFonts.rubik(
                  fontSize: 15,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
              subtitle: Text(
                myAudio.metas.artist!,
                style: GoogleFonts.rubik(
                  fontSize: 13,
                  color: Colors.grey,
                ),
                maxLines: 1,
              ),
              trailing: Container(
                height: 40.0,
                width: 40.0,
                margin: EdgeInsets.all(7.0),
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
                        ? IconButton(
                            onPressed: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 22,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 22,
                            ),
                          );
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
