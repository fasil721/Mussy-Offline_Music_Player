import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/controller/song_controller.dart';
import 'package:Mussy/widgets/home_popup_menu.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  String searchText = "";
  final songController = Get.find<SongController>();
  final _player = Player();
  Future<String> debounce() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return "Ok";
  }

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
          toolbarHeight: 60,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Search",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Search a song',
                  focusColor: const Color(0xff3a2d2d),
                  hoverColor: const Color(0xff3a2d2d),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff3a2d2d),
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xff3a2d2d),
                  fontSize: 16,
                ),
                onChanged: (value) {
                  searchText = value;
                  songController.update(["search"]);
                },
              ),
            ),
            GetBuilder<SongController>(
              id: "search",
              builder: (_) {
                List<Audio> result = searchText.isEmpty
                    ? []
                    : songController.songModels
                        .where(
                          (element) => element.metas.title!
                              .toLowerCase()
                              .startsWith(searchText.toLowerCase()),
                        )
                        .toList();
                return searchText.isEmpty
                    ? Container()
                    : result.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 75),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: result.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                    future: debounce(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              _player.openPlayer(index, result);
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            leading: QueryArtworkWidget(
                                              id: int.parse(
                                                  result[index].metas.id!),
                                              type: ArtworkType.AUDIO,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: const Image(
                                                  height: 50,
                                                  image: AssetImage(
                                                      "assets/icons/default.jpg"),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              result[index].metas.title!,
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                            ),
                                            subtitle: Text(
                                              result[index].metas.artist!,
                                              style: GoogleFonts.rubik(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                            ),
                                            trailing: HomePopup(
                                              audioId: result[index].metas.id!,
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No result found",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          );
              },
            )
          ],
        ),
      ),
    );
  }
}
