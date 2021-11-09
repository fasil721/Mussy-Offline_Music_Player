import 'package:Musify/databases/songs_adapter.dart';
import 'package:Musify/pages/settins_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  IconData btnIcon = Icons.play_arrow;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    requesrpermisson();
    super.initState();
  }

  var musics = Hive.box('songs');

  List<SongModel> tracks = [];
  List<Songs> audio = [];

  requesrpermisson() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    tracks = await _audioQuery.querySongs();
    audio = tracks
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

    musics.put("tracks", audio);
    setState(() {});
  }

  playingMusic(List<Songs> songs, index) {
    final _audio = Audio.file(
      songs[index].uri.toString(),
      metas: Metas(
        title: songs[index].title,
        artist: songs[index].artist,
      ),
    );
    if (_assetsAudioPlayer.isPlaying.value) {
      _assetsAudioPlayer.pause();
      _assetsAudioPlayer.open(
        _audio,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
      );
    } else {
      _assetsAudioPlayer.open(
        _audio,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
      );
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
          var box = musics.get("tracks");
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
