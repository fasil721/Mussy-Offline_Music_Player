import 'package:Musify/widgets/add_songs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlalistView extends StatefulWidget {
  const PlalistView({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  @override
  _PlalistViewState createState() => _PlalistViewState();
}

class _PlalistViewState extends State<PlalistView> {
  var playlists = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Center(
          child: Text(
            widget.playlistName,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 27,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (Context) => AddSongsInPlaylist(
                  playlistName: widget.playlistName,
                ),
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box('songs').listenable(),
        builder: (context, Box box, _) {
          playlists = box.get(widget.playlistName);
          return playlists.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.0,
                          horizontal: 16.0,
                        ),
                        tileColor: Color(0xff4D3C3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        onTap: () {},
                        // leading: Icon(
                        //   Icons.queue_music_rounded,
                        //   color: Colors.white,
                        //   size: 30,
                        // ),
                        // title: Text(
                        //   playlists[index],
                        //   textAlign: TextAlign.justify,
                        //   style: GoogleFonts.rubik(
                        //     fontSize: 20,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 15,
                  ),
                )
              : Center(
                  child: Text(
                    "No songs here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
