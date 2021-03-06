import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:Mussy/pages/settins_page.dart';
import 'package:Mussy/widgets/home_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Homepage extends StatelessWidget {
  Homepage(this._notify, {Key? key}) : super(key: key);
  // final List<Audio> audio;
  final bool _notify;
  final Box _box = Boxes.getInstance();
  final _player = Player();
  @override
  Widget build(BuildContext context) {
    List recentsongs = _box.get("recentsong");
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
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Mussy",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => SettingsPage(_notify));
              },
              icon: const Icon(Icons.settings),
            ),
            Container(
              width: 12,
            ),
          ],
        ),
        body: GetBuilder<SongController>(
          id: "home",
          builder: (_controller) {
            return _controller.songModels.isNotEmpty
                ? Padding(
                    padding: recentsongs.isEmpty
                        ? const EdgeInsets.only(bottom: 0)
                        : const EdgeInsets.only(bottom: 75),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _controller.songModels.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: ListTile(
                            onTap: () {
                              _player.openPlayer(
                                  index, _controller.songModels);
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              id: int.parse(
                                  _controller.songModels[index].metas.id!),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: const Image(
                                  height: 50,
                                  image: AssetImage("assets/icons/default.jpg"),
                                ),
                              ),
                            ),
                            title: Text(
                              _controller.songModels[index].metas.title!,
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              _controller.songModels[index].metas.artist!,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                            trailing: HomePopup(
                              audioId:
                                  _controller.songModels[index].metas.id!,
                            ),
                          ),
                        );
                      },
                    ),
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
