import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yout_favorites/api/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FavoritesBloc implements BlocBase {
  ///
  Map<String, Video> _favorites = {};

  final _favoritesController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFavs => _favoritesController.stream;

  FavoritesBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey("favorites")) {
        String armaz = prefs.getString("favorites")!;

        _favorites = json
            .decode(armaz)
            .map((k, v) => {k: Video.fromJson(v)})
            .cast<Map<String, Video>>();
        //
        _favoritesController.sink.add(_favorites);
      }
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }

    _favoritesController.sink.add(_favorites);

    _saveFavs();
  }

  void _saveFavs() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  YoutubePlayerController youtController = YoutubePlayerController(
    initialVideoId: 'K18cpp_-gP8',
    params: YoutubePlayerParams(
      // playlist: ['nPt8bK2gbaU', 'gQDByCdjUXw'], // Defining custom playlist
      // startAt: Duration(seconds: 30),
      showControls: true,
      showFullscreenButton: true,
    ),
  );

  @override
  void addListener(listener) {}

  @override
  void dispose() {
    _favoritesController.close();
    youtController.close();

    // youtController.p
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}
