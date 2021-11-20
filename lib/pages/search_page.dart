import 'package:Musify/audio_player/player.dart';
import 'package:Musify/widgets/home_popup_menu.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchPage extends StatefulWidget {
  SearchPage(this.audios);
  final List<Audio> audios;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";
  Future<String> debounce() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    return "Ok";
  }

  @override
  Widget build(BuildContext context) {
    List<Audio> result = widget.audios
        .where(
          (element) => element.metas.title!
              .toLowerCase()
              .startsWith(searchText.toLowerCase()),
        )
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Colors.black,
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
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search a song',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff4D3C3C),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          searchText.isNotEmpty
              ? result.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 75),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
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
                                        SongPlaying().openPlayer(index, result);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      leading: QueryArtworkWidget(
                                        id: int.parse(result[index].metas.id!),
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image(
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
                                      trailing: homepopup(
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
                  : Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "No result found",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
              : SizedBox(),
        ],
      ),
    );
  }
}
