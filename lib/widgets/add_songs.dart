import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddSongsInPlaylist extends StatefulWidget {
  const AddSongsInPlaylist(
      {Key? key, required this.playlistName, required this.playlists})
      : super(key: key);
  final String playlistName;
  final List<dynamic> playlists;
  @override
  _AddSongsInPlaylistState createState() => _AddSongsInPlaylistState();
}

class _AddSongsInPlaylistState extends State<AddSongsInPlaylist> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("songs");
    List<Songs> allsongs = box.get("tracks");

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
                var song = widget.playlists
                    .where(
                      (element) => element.id
                          .toString()
                          .contains(allsongs[index].id.toString()),
                    )
                    .toList();
                return song.isEmpty
                    ? IconButton(
                        onPressed: () {
                          widget.playlists.add(allsongs[index]);
                          box.put(widget.playlistName, widget.playlists);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          widget.playlists.remove(allsongs[index]);
                          box.put(widget.playlistName, widget.playlists);
                          print(
                            allsongs[index].title + "------------------------",
                          );
                          setState(() {});
                        },
                        icon:const Icon(
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
