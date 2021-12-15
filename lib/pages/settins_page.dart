import 'dart:async';
import 'package:Mussy/controller/song_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage(this._notify, {Key? key}) : super(key: key);
  final bool _notify;

  final songController = Get.find<SongController>();
  bool? val;
  bool _enabled = true;
  restartNotify() {
    if (_enabled) {
      _enabled = false;
      // songController.update(["switch"]);
      Get.snackbar(
        "Mussy",
        "App need restart to change the settings",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Timer(const Duration(seconds: 5), () {
        _enabled = true;
        // songController.update(["switch"]);
      });
    }
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
          leadingWidth: 70,
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Settings",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 27,
            ),
          ),
          titleSpacing: 30,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    right: 0,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    trailing: GetBuilder<SongController>(
                        id: "switch",
                        builder: (_) {
                          return Switch(
                            activeColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            value: val ?? _notify,
                            onChanged: (bool) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              val = bool;
                              prefs.setBool("notify", bool);
                              songController.update(["switch"]);
                              restartNotify();
                            },
                          );
                        }),
                    title: Text(
                      "Notification",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                    right: 0,
                  ),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Share",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                    right: 0,
                  ),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Privacy and policy",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                    right: 0,
                  ),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.receipt,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Terms and conditions",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    title: Text(
                      "About",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Musify',
                        applicationIcon: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: const Image(
                            height: 50,
                            image: AssetImage("assets/icons/icon.png"),
                          ),
                        ),
                        applicationVersion: '1.0.0',
                        children: [
                          const Text('Offline music player'),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "version",
                      style: GoogleFonts.rubik(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "1.0.0",
                    style: GoogleFonts.rubik(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
