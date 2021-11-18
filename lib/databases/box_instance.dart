import 'package:hive/hive.dart';

class Boxes {
  static Box? _box;
 
  static Box getInstance() {
    if (_box == null) {
      _box = Hive.box("songs");
    } 
    return _box!;
  }
}


