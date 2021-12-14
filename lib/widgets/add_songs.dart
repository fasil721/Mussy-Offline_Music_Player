import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
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
  final _box = Boxes.getInstance();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    List<Songs> allsongs = _box.get("tracks");

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Colors.black],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.grey,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search a song',
                focusColor: const Color(0xff3a2d2d),
                hoverColor: const Color(0xff3a2d2d),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff3a2d2d),
                ),
              ),
              style: const TextStyle(
                color: Color(0xff3a2d2d),
                fontSize: 16,
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
                        title: Text(
                          result[index].title,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                        ),
                        leading: QueryArtworkWidget(
                          id: result[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: const Image(
                              height: 50,
                              image: AssetImage("assets/icons/default.jpg"),
                            ),
                          ),
                        ),
                        trailing: AddAndRemove(
                          playlistName: widget.playlistName,
                          result: result[index],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Result not found"),
                )
        ],
      ),
    );
  }
}

class AddAndRemove extends StatefulWidget {
  const AddAndRemove(
      {Key? key, required this.playlistName, required this.result})
      : super(key: key);
  final String playlistName;
  final Songs result;
  @override
  _AddAndRemoveState createState() => _AddAndRemoveState();
}

class _AddAndRemoveState extends State<AddAndRemove> {
  final _box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    List<dynamic> playlists = _box.get(widget.playlistName);
    return playlists
            .where((element) =>
                element.id.toString() == widget.result.id.toString())
            .isEmpty
        ? IconButton(
            onPressed: () async {
              playlists.add(widget.result);
              await _box.put(widget.playlistName, playlists);
              setState(() {});
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white70,
            ),
          )
        : IconButton(
            onPressed: () async {
              playlists.removeWhere((element) =>
                  element.id.toString() == widget.result.id.toString());
              await _box.put(widget.playlistName, playlists);
              setState(() {});
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.white70,
            ),
          );
  }
}
