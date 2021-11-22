import 'package:Musify/pages/playlist_view.dart';
import 'package:Musify/widgets/create_playlist.dart';
import 'package:Musify/widgets/edit_playlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'favourite_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

List<dynamic> allKeys = [];
List<dynamic> playlists = [];

class _LibraryPageState extends State<LibraryPage> {
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
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Your Library",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (Context) => CreatePlaylist(),
                );
              },
              icon: Icon(
                Icons.add,
                size: 30,
              ),
            ),
            Container(
              width: 12,
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 15,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritePage(),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Favourites",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box('songs').listenable(),
                builder: (context, Box box, _) {
                  allKeys = box.keys.toList();
                  allKeys.remove("tracks");
                  allKeys.remove("favourites");
                  allKeys.remove("recentsong");
                  playlists = allKeys.toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 10,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0,
                            horizontal: 16.0,
                          ),
                          // tileColor: Color(0xff4D3C3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlalistView(
                                  playlistName: playlists[index],
                                ),
                              ),
                            );
                            print(playlists);
                          },
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext bc) => [
                              PopupMenuItem(
                                value: "0",
                                child: Text(
                                  "Edit playlist",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              PopupMenuItem(
                                value: "1",
                                child: Text(
                                  "Delete playlist",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "1") {
                                box.delete(playlists[index]);
                              }
                              if (value == "0") {
                                showDialog(
                                  context: context,
                                  builder: (Context) => EditPlaylist(
                                    PlaylistName: playlists[index],
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          leading: Icon(
                            Icons.queue_music_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            playlists[index],
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
