import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/pages/playing_screen.dart';
import 'package:Mussy/widgets/add_songs.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlalistView extends StatefulWidget {
  const PlalistView({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  @override
  _PlalistViewState createState() => _PlalistViewState();
}

class _PlalistViewState extends State<PlalistView> {
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3a2d2d), Colors.black],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: IconButton(
              icon: const Icon(
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
                  builder: (context) => AddSongsInPlaylist(
                    playlistName: widget.playlistName,
                  ),
                );
              },
              icon: const Icon(
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
          valueListenable: Boxes.getInstance().listenable(),
          builder: (context, Box _box, _) {
            List playlists = _box.get(widget.playlistName);

            List<Audio> audios = Player().convertToAudios(playlists);
            return playlists.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: ListTile(
                          // tileColor: Color(0xff4D3C3C),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          title: Text(
                            playlists[index].title!,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            playlists[index].artist!,
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext bc) => [
                              const PopupMenuItem(
                                value: "1",
                                child: Text(
                                  "Remove song",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "1") {
                                playlists.removeAt(index);
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            id: playlists[index].id!,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: const Image(
                                height: 50,
                                image: AssetImage("assets/icons/default.jpg"),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicView(audio: audios),
                              ),
                            );
                            _assetsAudioPlayer.stop();
                            Player().openPlayer(index, audios);
                          },
                        ),
                      );
                    },
                  )
                : const Center(
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
      ),
    );
  }
}
