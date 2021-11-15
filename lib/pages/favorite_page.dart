import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/cupertino.dart';
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
  var val = true;
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
          List<dynamic> favorites = box.get("favorites");
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
                              value: "0",
                              child: Text(
                                "Add to favorite",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            PopupMenuItem(
                              value: "1",
                              child: Text(
                                "Delete song",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "1") {
                              favorites.removeAt(index);
                              setState(() {
                                favorites.clear();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),

                        onTap: () {
                          // playlists.clear();
                          // openPlayer(index);
                          // print(audios1.length.toString() +
                          //     "-------------------------------");
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
