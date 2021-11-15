import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import './pages/home_page.dart';
import './pages/library_page.dart';
import './pages/search_page.dart';
import 'databases/songs_adapter.dart';
import 'pages/bottom_play.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox('songs');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    requesrpermisson();
    super.initState();
  }

  var musics = Hive.box('songs');
  List<SongModel> tracks = [];
  List<Songs> audio = [];
  List<Audio> songModels = [];
  // List<dynamic> favorites = [];
  requesrpermisson() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (await !permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    tracks = await _audioQuery.querySongs();
    audio = tracks
        .map(
          (e) => Songs(
            title: e.title,
            artist: e.artist,
            uri: e.uri,
            id: e.id,
          ),
        )
        .toList();
    tracks.forEach(
      (element) {
        songModels.add(
          Audio.file(
            element.uri.toString(),
            metas: Metas(
              title: element.title,
              artist: element.artist,
              id: element.id.toString(),
            ),
          ),
        );
      },
    );
    // print(tracks[0].fileExtension+"-------------------------------------------------");
    await musics.put("tracks", audio);
    await musics.put("favorites", playlists);
    setState(() {});
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      Homepage(songModels),
      SearchPage(),
      LibraryPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          IndexedStack(
            children: screens,
            index: currentIndex,
          ),
          bottomPlating(audio: songModels),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
        backgroundColor: Colors.black,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) => setState(
          () {
            // var music = Hive.box("songs");
            // List<Songs> a = music.get("tracks");
            // print(a[0].title);
            currentIndex = index;
          },
        ),
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/home.png"),
              size: 25,
            ),
            label: 'Home',
            // backgroundColor: Color(_black),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/search.png"),
              size: 25,
            ),
            label: 'Search',
            // backgroundColor: Color(_black),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/library.png"),
              size: 25,
            ),
            label: 'Library',
            // backgroundColor: Color(_black),
          ),
        ],
      ),
    );
  }
}
