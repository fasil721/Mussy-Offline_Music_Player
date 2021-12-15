import 'package:Mussy/audio_player/player.dart';
import 'package:Mussy/databases/box_instance.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/song_controller.dart';
import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/search_page.dart';
import 'databases/songs_adapter.dart';
import 'pages/bottom_playing_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox('songs');
  Box _box = Boxes.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  List keys = _box.keys.toList();
  final prefs = await SharedPreferences.getInstance();
  if (keys.isEmpty) {
    List<Songs> favourites = [];
    await _box.put("favourites", favourites);
    List<Songs> recentSong = [];
    await _box.put("recentsong", recentSong);
    await prefs.setBool('notify', true);
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  bool? _notify = prefs.getBool('notify');

  List recentSongs = _box.get("recentsong");
  final _player = Player();
  if (recentSongs.isNotEmpty) {
    final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
    List<Audio> audios = _player.convertToAudios(recentSongs);
    _assetsAudioPlayer.open(
      Playlist(
        audios: audios,
        startIndex: 0,
      ),
      autoStart: false,
      loopMode: LoopMode.playlist,
    );
  }

  runApp(
    FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Splash(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return GetMaterialApp(
            getPages: [
              GetPage(
                name: "/main",
                page: () => MyApp(_notify!),
                binding: SongBinding(),
              )
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: "/main",
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff3a2d2d),
            Colors.black,
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
            child: const Image(
              height: 150,
              image: AssetImage("assets/icons/icon.png"),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp(this._notify, {Key? key}) : super(key: key);
  final bool _notify;

  int currentIndex = 0;
  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    final screens = [
      Homepage(_notify),
      SearchPage(),
      LibraryPage(),
    ];
    return GetBuilder<SongController>(
      id: "navbar",
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              IndexedStack(
                children: screens,
                index: currentIndex,
              ),
              BottomPlaying(),
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
            onTap: (index) {
              currentIndex = index;
              songController.update(["navbar"]);
            },
            items: const [
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
      },
    );
  }
}
