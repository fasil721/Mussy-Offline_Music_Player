import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

var musics = Hive.box('songs');
String? _title;
final formkey = GlobalKey<FormState>();

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({Key? key}) : super(key: key);

  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  List<dynamic> playlists = [];
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AlertDialog(
          shape: Border.all(
            width: 1,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  "Give your playlist a name.",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      if (value == "") {
                        return "Name required";
                      }
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15,
                        top: 5,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15,
                        top: 5,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              musics.put(_title, playlists);
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            "Create",
                            style: GoogleFonts.rubik(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
