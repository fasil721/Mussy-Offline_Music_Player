import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  var val = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Settings",
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 15,
              right: 0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              trailing: Switch(
                value: val,
                onChanged: (bool) {},
              ),
              title: Text(
                "Notification",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 5,
              right: 0,
            ),
            child: ListTile(
              title: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "About",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'Flutter',
                    applicationIcon: FlutterLogo(),
                    applicationVersion: '1.0.0',
                    children: [
                      Text('dakhdsadhjdfklhgfd'),
                    ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
