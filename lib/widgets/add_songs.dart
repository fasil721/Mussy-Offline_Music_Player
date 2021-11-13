import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddSongsInPlaylist extends StatefulWidget {
  const AddSongsInPlaylist({Key? key, required this.playlistName})
      : super(key: key);
  final String playlistName;
  // final List<dynamic> playlists;
  @override
  _AddSongsInPlaylistState createState() => _AddSongsInPlaylistState();
}

class _AddSongsInPlaylistState extends State<AddSongsInPlaylist> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("songs");
    List<Songs> allsongs = box.get("tracks");
    List<dynamic> playlists = box.get(widget.playlistName);
    return Container(
      color: Colors.grey,
      child: ListView.separated(
        itemCount: allsongs.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.white,
            title: Text(allsongs[index].title),
            leading: QueryArtworkWidget(
              id: allsongs[index].id,
              type: ArtworkType.AUDIO,
            ),
            trailing: Builder(
              builder: (context) {
                var song = playlists
                    .where(
                      (element) => element.id
                          .toString()
                          .contains(allsongs[index].id.toString()),
                    )
                    .toList();
                return song.isEmpty
                    ? IconButton(
                        onPressed: () async {
                          playlists.add(allsongs[index]);
                          await box.put(widget.playlistName, playlists);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          playlists.removeWhere((element) =>
                              element.title == allsongs[index].title);
                          await box.put(widget.playlistName, playlists);
                          print(
                            allsongs[index].title + "------------------------",
                          );
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.check_box,
                        ),
                      );
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}
