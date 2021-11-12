import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddSongsInPlaylist extends StatefulWidget {
  const AddSongsInPlaylist({Key? key, required this.playlistName})
      : super(key: key);
  final String playlistName;
  @override
  _AddSongsInPlaylistState createState() => _AddSongsInPlaylistState();
}

class _AddSongsInPlaylistState extends State<AddSongsInPlaylist> {
  var playlists = [];
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("songs");
    List<Songs> allsongs = box.get("tracks");
    playlists = box.get(widget.playlistName);
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
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
              ),
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
