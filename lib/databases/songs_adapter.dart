import 'package:hive/hive.dart';

part 'songs_adapter.g.dart';

@HiveType(typeId: 1)
class Songs extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  String? uri;
  @HiveField(3)
  int? id;
  @HiveField(4)
  int? duration;

  Songs({
    required this.title,
    required this.artist,
    required this.uri,
    required this.id,
    required this.duration,
  });
}
