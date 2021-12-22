import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/pages/playing_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key}) : super(key: key);
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
          leadingWidth: 70,
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Favourites",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        body: GetBuilder<SongController>(
          id: "favs",
          builder: (_controller) {
            List favourites = _controller.box.get("favourites");
            List<Audio> audios = _player.convertToAudios(favourites);
            return favourites.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          title: Text(
                            favourites[index].title!,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            favourites[index].artist!,
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                          ),
                          leading: QueryArtworkWidget(
                            id: favourites[index].id!,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: const Image(
                                height: 50,
                                image: AssetImage("assets/icons/default.jpg"),
                              ),
                            ),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext bc) => [
                              const PopupMenuItem(
                                value: "1",
                                child: Text(
                                  "Remove Song",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "1") {
                                favourites.removeAt(index);
                                _controller.update(["favs"]);
                              }
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            // _assetsAudioPlayer.pause();
                            _assetsAudioPlayer.stop();
                            _player.openPlayer(index, audios);
                            Get.to(() => MusicView(audio: audios));
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
