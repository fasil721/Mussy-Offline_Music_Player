import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/databases/songs_adapter.dart';
import 'package:Mussy/widgets/add_to_playlist.dart';
import 'package:flutter/material.dart';

class HomePopup extends StatefulWidget {
  const HomePopup({Key? key, required this.audioId}) : super(key: key);
  final String audioId;
  @override
  _HomePopupState createState() => _HomePopupState();
}

class _HomePopupState extends State<HomePopup> {
  final _box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    List<Songs> songs = _box.get("tracks");
    List<dynamic> favourites = _box.get("favourites");
    final temp = Player().findSongFromDatabase(songs, widget.audioId);
    return PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        favourites
                .where((element) => element.id.toString() == temp.id.toString())
                .isEmpty
            ? PopupMenuItem(
                onTap: () async {
                  favourites.add(temp);
                  await _box.put("favourites", favourites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(temp.title + " Added to Favourites"),
                    ),
                  );
                },
                child: const Text("Add to favourite"),
              )
            : PopupMenuItem(
                onTap: () async {
                  favourites.removeWhere(
                      (element) => element.id.toString() == temp.id.toString());
                  await _box.put("favourites", favourites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(temp.title + " Removed from Favourites"),
                    ),
                  );
                },
                child: const Text("Remove from favourite"),
              ),
        const PopupMenuItem(
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
      icon: const Icon(
        Icons.more_horiz,
        color: Colors.white,
      ),
    );
  }
}
