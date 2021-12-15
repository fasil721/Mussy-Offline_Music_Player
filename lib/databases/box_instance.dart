import 'package:hive/hive.dart';

class Boxes {
  static Box? _box;
  
  static Box getInstance() {
    _box ??= Hive.box("songs");
    return _box!;
  }
}
