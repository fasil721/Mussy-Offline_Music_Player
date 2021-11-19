import 'package:Musify/audio_player/song_playing.dart';
import 'package:Musify/pages/settins_page.dart';
import 'package:Musify/widgets/home_popup_menu.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Homepage extends StatefulWidget {
  Homepage(this.audio, this._notify);
  final List<Audio> audio;
  final bool _notify;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4D3C3C), Color(0xff000000)],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 0.9),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Musify",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(widget._notify),
                  ),
                );
              },
              icon: Icon(Icons.settings),
            ),
            Container(
              width: 12,
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              widget.audio.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.audio.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 0,
                          ),
                          child: ListTile(
                            onTap: () {
                              SongPlaying().openPlayer(index, widget.audio);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              id: int.parse(widget.audio[index].metas.id!),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  height: 50,
                                  image: AssetImage("assets/icons/default.jpg"),
                                ),
                              ),
                            ),
                            title: Text(
                              widget.audio[index].metas.title!,
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              widget.audio[index].metas.artist!,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                            trailing: homepopup(
                              audioId: widget.audio[index].metas.id!,
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No songs here",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
              SizedBox(
                height: 75,
              )
            ],
          ),
        ),
      ),
    );
  }
}
