import 'package:Musify/databases/box_instance.dart';
import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddSongsInPlaylist extends StatefulWidget {
  const AddSongsInPlaylist({
    Key? key,
    required this.playlistName,
  }) : super(key: key);
  final String playlistName;

  @override
  _AddSongsInPlaylistState createState() => _AddSongsInPlaylistState();
}

class _AddSongsInPlaylistState extends State<AddSongsInPlaylist> {
  Box _box = Boxes.getInstance();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    List<Songs> allsongs = _box.get("tracks");
    List<dynamic> playlists = _box.get(widget.playlistName);
    List<Songs> result = searchText.isEmpty
        ? allsongs.toList()
        : allsongs
            .where(
              (element) => element.title
                  .toLowerCase()
                  .contains(searchText.toLowerCase()),
            )
            .toList();
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              10,
            ),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search a song',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff4D3C3C),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          result.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(result[index].title),
                        leading: QueryArtworkWidget(
                          id: result[index].id,
                          type: ArtworkType.AUDIO,
                        ),
                        trailing: Builder(
                          builder: (context) {
                            return playlists
                                    .where((element) =>
                                        element.id.toString() ==
                                        result[index].id.toString())
                                    .isEmpty
                                ? IconButton(
                                    onPressed: () async {
                                      playlists.add(result[index]);
                                      await _box.put(
                                          widget.playlistName, playlists);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      playlists.removeWhere((element) =>
                                          element.title == result[index].title);
                                      await _box.put(
                                          widget.playlistName, playlists);

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
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Result not found"),
                )
        ],
      ),
    );
  }
}
