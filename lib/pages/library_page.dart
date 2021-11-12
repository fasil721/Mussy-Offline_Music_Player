import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/create_playlist.dart';
import 'favorite_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  var musics = Hive.box('songs');
  List<dynamic> allKeys = [];
  List<dynamic> playlists = [];

  @override
  Widget build(BuildContext context) {
    allKeys = musics.keys.toList();
    allKeys.remove("tracks");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black,
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
                builder: (Context) => CreatePlaylist(),
              );
            },
            icon: Icon(
              Icons.add,
              size: 30,
            ),
          ),
          Container(
            width: 12,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 25,
              left: 25,
              bottom: 15,
            ),
            child: ListTile(
              tileColor: Color(0xff4D3C3C),
              onTap: () {
                musics.clear();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => FavoritePage(),
                //   ),
                // );
              },
              contentPadding: EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 16.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              leading: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              title: Text(
                "Favorites",
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: allKeys.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  onTap: () {
                    print(allKeys);
                  },
                  tileColor: Colors.white,
                  title: Text(allKeys[index]),
                  trailing: Icon(Icons.ac_unit),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 15,
            ),
          ),
        ],
      ),
    );
  }
}
