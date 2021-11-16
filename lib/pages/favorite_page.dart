import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  List<dynamic> favorites = [];
  List<Audio> audios = [];
  openPlayer(int index) async {
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: index),
      showNotification: true,
      autoStart: true,
      playInBackground: PlayInBackground.enabled,
      loopMode: LoopMode.playlist,
      notificationSettings: NotificationSettings(stopEnabled: false),
    );
  }

  playFavorites(Box box) async {
    favorites = box.get("favorites");
    audios = [];
    favorites.forEach(
      (element) {
        audios.add(
          Audio.file(
            element.uri.toString(),
            metas: Metas(
              title: element.title,
              artist: element.artist,
              id: element.id.toString(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Favorutes",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('songs').listenable(),
        builder: (context, Box box, _) {
          playFavorites(box);
          return favorites.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: ListTile(
                        // tileColor: Color(0xff4D3C3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        title: Text(
                          favorites[index].title!,
                          maxLines: 1,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.rubik(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          favorites[index].artist!,
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                        leading: QueryArtworkWidget(
                          id: favorites[index].id!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              height: 50,
                              image: AssetImage("assets/icons/default.jpg"),
                            ),
                          ),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext bc) => [
                            PopupMenuItem(
                              value: "1",
                              child: Text(
                                "Remove Song",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "1") {
                              favorites.removeAt(index);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),

                        onTap: () {
                          openPlayer(index);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No songs here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
