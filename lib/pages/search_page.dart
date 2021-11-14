import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black,
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              tileColor: Color(0xffC4C4C4),
              leading: QueryArtworkWidget(
                id: 0,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 50,
                    image: AssetImage("assets/icons/default.jpg"),
                  ),
                ),
              ),
              title: Text(
                "Darshana",
                maxLines: 1,
              ),
              subtitle: Text(
                "unknown",
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              tileColor: Color(0xffC4C4C4),
              leading: QueryArtworkWidget(
                id: 0,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 50,
                    image: AssetImage("assets/icons/default.jpg"),
                  ),
                ),
              ),
              title: Text(
                "Thattum muttum thalam",
                maxLines: 1,
              ),
              subtitle: Text(
                "unknown",
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              tileColor: Color(0xffC4C4C4),
              leading: QueryArtworkWidget(
                id: 0,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 50,
                    image: AssetImage("assets/icons/default.jpg"),
                  ),
                ),
              ),
              title: Text(
                "Uyire",
                maxLines: 1,
              ),
              subtitle: Text(
                "unknown",
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              tileColor: Color(0xffC4C4C4),
              leading: QueryArtworkWidget(
                id: 0,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    height: 50,
                    image: AssetImage("assets/icons/default.jpg"),
                  ),
                ),
              ),
              title: Text(
                "Mazhamegham",
                maxLines: 1,
              ),
              subtitle: Text(
                "unknown",
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
