import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:Mussy/widgets/create_playlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToPlaylist extends StatelessWidget {
  AddToPlaylist({Key? key, required this.song}) : super(key: key);
  final Songs song;
  final _box = Boxes.getInstance();
  final songController = Get.find<SongController>();
  @override
  Widget build(BuildContext context) {
    List playlistNames = _box.keys.toList();
    playlistNames.remove("tracks");
    playlistNames.remove("favourites");
    playlistNames.remove("recentsong");
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Colors.black],
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
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Create a new Playlist",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: playlistNames.length,
              itemBuilder: (context, index) {
                List songofPlaylist = _box.get(playlistNames[index]);
                return Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: ListTile(
                    leading: const Icon(
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
                    trailing: GetBuilder<SongController>(
                      id: "addplay",
                      builder: (_) {
                        return songofPlaylist
                                .where((element) =>
                                    element.id.toString() == song.id.toString())
                                .isEmpty
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                                onPressed: () async {
                                  List songofPlaylist =
                                      _box.get(playlistNames[index]);
                                  songofPlaylist.add(song);
                                  await _box.put(
                                      playlistNames[index], songofPlaylist);
                                  Get.back();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        song.title! +
                                            " added to Playlist " +
                                            playlistNames[index],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
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
                                        song.id.toString(),
                                  );
                                  await _box.put(
                                      playlistNames[index], songofPlaylist);
                                  songController.update(["addplay"]);
                                },
                                child: const Text(
                                  "Remove",
                                  style: TextStyle(
                                    color: Color(0xff3a2d2d),
                                  ),
                                ),
                              );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
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
