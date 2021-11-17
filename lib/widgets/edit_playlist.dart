import 'package:Musify/databases/box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class EditPlaylist extends StatefulWidget {
  const EditPlaylist({Key? key, required this.PlaylistName}) : super(key: key);
  final PlaylistName;
  @override
  _EditPlaylistState createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  Box _box = Boxes.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
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
                  "Edit your playlist name.",
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
                    initialValue: widget.PlaylistName,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      List<dynamic> keys = _box.keys.toList();
                      if (value == "") {
                        return "Name required";
                      }
                      if (keys
                          .where((element) => element == value)
                          .isNotEmpty) {
                        return "This name already exits";
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
                            List<dynamic> playlists =
                                _box.get(widget.PlaylistName);
                            setState(() {
                              _box.put(_title, playlists);
                              _box.delete(widget.PlaylistName);
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            "Save",
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
