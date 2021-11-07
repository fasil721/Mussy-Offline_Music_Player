import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/home_page.dart';
import './pages/library_page.dart';
import './pages/search_page.dart';

void main() {
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
    super.initState();
    requestPermission();
    getSongs();
  }

  requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    setState(() {});
  }

  List<SongModel> songs = [];
  Future getSongs() async {
    songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  int currentIndex = 0;

  final screens = [
    Homepage(),
    SearchPage(),
    LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        children: screens,
        index: currentIndex,
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
