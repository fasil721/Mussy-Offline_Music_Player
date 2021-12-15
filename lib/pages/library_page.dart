import 'package:Mussy/pages/playlist_view.dart';
import 'package:Mussy/widgets/create_playlist.dart';
import 'package:Mussy/widgets/edit_playlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'favourite_page.dart';

// ignore: must_be_immutable
class LibraryPage extends StatelessWidget {
  LibraryPage({Key? key}) : super(key: key);

  List allKeys = [];
  List playlists = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Colors.black],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1),
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
                  builder: (context) => CreatePlaylist(),
                );
              },
              icon: const Icon(
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 16.0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  leading: const Icon(
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
                    physics: const ScrollPhysics(),
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 10,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 3.0,
                            horizontal: 16.0,
                          ),
                          // tileColor: Color(0xff4D3C3C),
                          shape: const RoundedRectangleBorder(
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
                          },
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext bc) => [
                              const PopupMenuItem(
                                value: "0",
                                child: Text(
                                  "Edit playlist",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const PopupMenuItem(
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
                                  builder: (context) => EditPlaylist(
                                    playlistName: playlists[index],
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          leading: const Icon(
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
