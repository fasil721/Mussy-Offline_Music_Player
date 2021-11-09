import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/pages/settins_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool isPlaying = false;
  IconData btnIcon = Icons.play_arrow;

  playingMusic(songs, index) {
    if (isPlaying) {
      final audio = Audio.file(
        songs[index].uri.toString(),
        metas: Metas(
          title: songs[index].title,
          artist: songs[index].artist,
        ),
      );
      _assetsAudioPlayer.pause();
      _assetsAudioPlayer.open(
        audio,
        showNotification: true,
      );
    } else {
      _assetsAudioPlayer.open(
        Audio.file(
          songs[index].uri.toString(),
        ),
        showNotification: true,
      );

      // setState(() {
      //   isPlaying = true;
      //   btnIcon = Icons.pause;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Musify",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
          Container(
            width: 12,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          var music = Hive.box("songs");
          var box = music.get("tracks");
          return box != null
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: ListTile(
                        onTap: () {
                          playingMusic(box, index);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        tileColor: Color(0xffC4C4C4),
                        leading: QueryArtworkWidget(
                          id: box[index].id,
                          type: ArtworkType.AUDIO,
                        ),
                        title: Text(box[index].title),
                        subtitle: Text(box[index].artist!),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No songs here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
