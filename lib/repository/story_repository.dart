import 'dart:convert';
import 'package:http/http.dart';

enum MediaType { image, video, text }

class UserStory {
  final MediaType? mediaType;
  final String? media;
  final double? duration;
  final String? caption;
  final String? when;
  final String? color;

  UserStory({
    this.mediaType,
    this.media,
    this.duration,
    this.caption,
    this.when,
    this.color,
  });
}
class Repository {
  static MediaType _translateType(String? type) {
    if (type == "image") {
      return MediaType.image;
    }

    if (type == "video") {
      return MediaType.video;
    }

    return MediaType.text;
  }

  static Future<List<UserStory>> getUserStories() async {
    const uri = "https://raw.githubusercontent.com/Neelambansal/story_viewer/master/lib/data/userstory.json";
    final response = await get(Uri.parse(uri));

    final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];

    final res = data.map<UserStory>((it) {
      return UserStory(
          caption: it['caption'],
          media: it['media'],
          duration: double.parse(it['duration']),
          when: it['when'],
          mediaType: _translateType(it['mediaType']),
          color: it['color']);
    }).toList();

    return res;
  }
}
