import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yout_favorites/api/video.dart';

class FavoritesBloc implements BlocBase {
  ///
  Map<String, Video> _favorites = {};

  final _favoritesController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFavs => _favoritesController.stream;

  FavoritesBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey("favorites")) {
        String armaz = prefs.getString("favorites")!;
        var decod = json.decode(armaz);

        _favorites = decod.map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
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

  @override
  void addListener(listener) {}

  @override
  void dispose() {
    _favoritesController.close();

    // youtController.p
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}
