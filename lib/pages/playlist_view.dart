import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/pages/playing_screen.dart';
import 'package:Mussy/widgets/add_songs.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlalistView extends StatelessWidget {
  PlalistView({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final _player = Player();
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
                Get.back();
              },
            ),
          ),
          title: Center(
            child: Text(
              playlistName,
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
                    playlistName: playlistName,
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
        body: GetBuilder<SongController>(
          id: "playlist",
          builder: (_controller) {
            List playlists = _controller.box.get(playlistName);
            List<Audio> audios = _player.convertToAudios(playlists);
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
                                _controller.update(["playlist"]);
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
                            Get.to(() => MusicView(audio: audios));
                            _assetsAudioPlayer.stop();
                            _player.openPlayer(index, audios);
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
