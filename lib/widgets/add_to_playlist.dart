import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/widgets/create_playlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class AddToPlaylist extends StatefulWidget {
  const AddToPlaylist({Key? key, required this.song}) : super(key: key);
  final song;
  @override
  _AddToPlaylistState createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  Box _box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    List<dynamic> playlistNames = _box.keys.toList();
    playlistNames.remove("tracks");
    playlistNames.remove("favourites");
    playlistNames.remove("recentsong");

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Color(0xff0000000)],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreatePlaylist(),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ), 
                title: Text(
                  "Create a new Playlist",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: playlistNames.length,
              itemBuilder: (context, index) {
                List<dynamic> songofPlaylist = _box.get(playlistNames[index]);
                return Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: ListTile(
                    onTap: () {
                      print(widget.song);
                    },
                    leading: Icon(
                      Icons.queue_music_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                      playlistNames[index],
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.rubik(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    trailing: songofPlaylist
                            .where((element) =>
                                element.id.toString() ==
                                widget.song.id.toString())
                            .isEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            onPressed: () async {
                              List<dynamic> songofPlaylist =
                                  _box.get(playlistNames[index]);
                              songofPlaylist.add(widget.song);
                              await _box.put(
                                  playlistNames[index], songofPlaylist);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.song.title +
                                        " added to Playlist " +
                                        playlistNames[index],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Color(0xff3a2d2d),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            onPressed: () async {
                              songofPlaylist.removeWhere(
                                (element) =>
                                    element.id.toString() ==
                                    widget.song.id.toString(),
                              );
                              await _box.put(
                                  playlistNames[index], songofPlaylist);
                              setState(() {});
                            },
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                color: Color(0xff3a2d2d),
                              ),
                            ),
                          ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 16.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
