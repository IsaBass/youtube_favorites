import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:yout_favorites/api/api.dart';
import 'package:yout_favorites/api/video.dart';

class VideosBloc implements BlocBase {
  late Api api;

  List<Video> videos = <Video>[];

  VideosBloc() {
    api = Api();
    _searchController.stream.listen((v) => _search(v));
  }

  final _videosController = BehaviorSubject<List<Video>>();
  Stream<List<Video>> get outVideos => _videosController.stream;

  final _searchController = BehaviorSubject<String>();
  Sink get inSearch => _searchController.sink;

  void _search(String search) async {
    if (search != "") {
      _videosController.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videosController.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }
}
