import 'package:Musify/databases/songs_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var val = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Favorutes",
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        // body: Column(
        //   children: [
        //     Align(
        //       alignment: Alignment.topCenter,
        //       child: Text(
        //         "Favorites",
        //         style: GoogleFonts.rubik(
        //           color: Colors.white,
        //           fontSize: 30,
        //         ),
        //       ),
        //     ),
        //     favs.isNotEmpty
        //         ? ListView.builder(
        //             shrinkWrap: true,
        //             physics: ScrollPhysics(),
        //             itemCount: favs.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 trailing: Icon(Icons.ac_unit),
        //               );
        //             },
        //           )
        //         : Center(child: Text("data")),
        //   ],
        // ),
      ),
    );
  }
}
