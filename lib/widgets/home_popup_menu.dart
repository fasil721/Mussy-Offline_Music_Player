import 'package:Musify/databases/box.dart';
import 'package:Musify/databases/songs_adapter.dart';
import 'package:Musify/widgets/add_to_playlist.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class homepopup extends StatefulWidget {
  const homepopup({Key? key, required this.audioId}) : super(key: key);
  final String audioId;
  @override
  _homepopupState createState() => _homepopupState();
}

class _homepopupState extends State<homepopup> {
  Box _box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    List<Songs> song = _box.get("tracks");
    List<dynamic> favorites = _box.get("favorites");
    final temp = song.firstWhere(
      (element) => element.id.toString().contains(widget.audioId),
    );

    return PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        favorites
                .where((element) => element.id.toString() == temp.id.toString())
                .isEmpty
            ? PopupMenuItem(
                onTap: () async {
                  favorites.add(temp);
                  await _box.put("favorites", favorites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(temp.title + " Added to Favorites"),
                    ),
                  );
                },
                child: Text("Add to favorite"),
              )
            : PopupMenuItem(
                onTap: () async {
                  favorites.removeWhere(
                      (element) => element.id.toString() == temp.id.toString());
                  await _box.put("favorites", favorites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(temp.title + " Removed from Favorites"),
                    ),
                  );
                },
                child: Text("Remove from favorite"),
              ),
        PopupMenuItem(
          child: Text("Add to playlist"),
          value: "1",
        ),
      ],
      onSelected: (value) async {
        if (value == "1") {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddToPlaylist(song: temp),
          );
        }
      },
      icon: Icon(
        Icons.more_horiz,
        color: Colors.white,
      ),
    );
  }
}
