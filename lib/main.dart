import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'pages/bottom_playing_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox('songs');
  Box _box = await Boxes.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  List<dynamic> keys = _box.keys.toList();
  if (keys.isEmpty) {
    List<dynamic> favourites = [];
    await _box.put("favourites", favourites);
    List<dynamic> recentsong = [];
    await _box.put("recentsong", recentsong);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify', true);
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _notify = await prefs.getBool('notify');

  List<dynamic> recentsongs = _box.get("recentsong");
  if (recentsongs.isNotEmpty) {
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
    List<Audio> audios = Player().convertToAudios(recentsongs);
    _assetsAudioPlayer.open(
      Playlist(
        audios: audios,
        startIndex: 0,
      ),
      autoStart: false,
    );
  }

  runApp(
    FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyApp(_notify!),
          );
        }
      },
    ),
  );
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff3a2d2d),
            Color(0xff0000000),
          ],
          begin: Alignment.topLeft,
          end: FractionalOffset(0, 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              height: 180,
              image: AssetImage("assets/icons/icon.png"),
            ),
          ),
        ),
      ),
    );
  }
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
  List<SongModel> musics = [];
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

    tracks.forEach((element) {
      if (element.fileExtension == "mp3" || element.fileExtension == "opus") {
        musics.add(element);
      }
    });
    print(musics.length);
    audio = musics
        .map(
          (e) => Songs(
            title: e.title,
            artist: e.artist,
            uri: e.uri,
            id: e.id,
            duration: e.duration,
          ),
        )
        .toList();
    songModels = Player().convertToAudios(musics);
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
