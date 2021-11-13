import 'package:Musify/pages/settins_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Homepage extends StatefulWidget {
  Homepage(this.audio);
  final List<Audio> audio;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  openPlayer(int index) async {
    await _assetsAudioPlayer.open(
      Playlist(audios: widget.audio, startIndex: index),
      showNotification: true,
      autoStart: true,
      playInBackground: PlayInBackground.enabled,
      loopMode: LoopMode.playlist,
      notificationSettings: NotificationSettings(stopEnabled: false),
    );
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
          return widget.audio.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.audio.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 0,
                      ),
                      child: ListTile(
                        onTap: () {
                          openPlayer(index);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        // tileColor: Color(0xffC4C4C4),
                        leading: QueryArtworkWidget(
                          id: int.parse(widget.audio[index].metas.id!),
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
                          widget.audio[index].metas.title!,
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          widget.audio[index].metas.artist!,
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 0,
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
