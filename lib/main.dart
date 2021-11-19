import 'package:Musify/databases/box_instance.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/search_page.dart';
import 'databases/songs_adapter.dart';
import 'pages/bottom_play.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox('songs');
  Box _box = await Boxes.getInstance();
  List<dynamic> keys = _box.keys.toList();
  if (keys.isEmpty) {
    List<dynamic> favorites = [];
    await _box.put("favorites", favorites);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify', true);
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _notify = await prefs.getBool('notify');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(_notify!),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp(this._notify);
  final bool _notify;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  int currentIndex = 0;
  Box _box = Boxes.getInstance();
  List<SongModel> tracks = [];
  List<Songs> audio = [];
  List<Audio> songModels = [];

  @override
  void initState() {
    requesrpermisson();
    super.initState();
  }

  requesrpermisson() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
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
    await _box.put("tracks", audio);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      Homepage(songModels, widget._notify),
      SearchPage(songModels),
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
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/search.png"),
              size: 25,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/icons/library.png"),
              size: 25,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
