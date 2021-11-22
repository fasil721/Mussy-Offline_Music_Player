import 'package:Musify/audio_player/player.dart';
import 'package:Musify/databases/box_instance.dart';
import 'package:Musify/pages/playing_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Color(0xff0000000)],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1.3),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 70,
          toolbarHeight: 80,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Favourites",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: Boxes.getInstance().listenable(),
          builder: (context, Box _box, _) {
            List<dynamic> favourites = _box.get("favourites");
            List<Audio> audios = Player().convertToAudios(favourites);
            return favourites.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          title: Text(
                            favourites[index].title!,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            favourites[index].artist!,
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                          ),
                          leading: QueryArtworkWidget(
                            id: favourites[index].id!,
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
                                favourites.removeAt(index);
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicView(audio: audios),
                              ),
                            );
                            Player().openPlayer(index, audios);
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
      ),
    );
  }
}
