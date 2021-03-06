import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yout_favorites/api/secrets.dart';
import 'package:yout_favorites/api/video.dart';

final String apiKey = Secrets.ggAPIKEY;

/*
"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"

"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"

"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"



*/

class Api {
  String _nextToken = "";
  String _search = "";

  Future<List<Video>> search(String search) async {
    _search = search;
    //
    http.Response resp = await http.get(
      Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$apiKey&maxResults=10",
      ),
    );
    //
    return decode(resp);
  }

  Future<List<Video>> nextPage() async {
    //
    http.Response resp = await http.get(
      Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$apiKey&maxResults=10&pageToken=$_nextToken",
      ),
    );
    //
    return decode(resp);
  }

  List<Video> decode(http.Response resp) {
    if (resp.statusCode != 200) {
      throw Exception(
          "Falha ao chamar API videos ${resp.statusCode}  ${resp.reasonPhrase}");
    }

    var mapa = <String, dynamic>{};
    mapa = json.decode(resp.body);

    _nextToken = mapa['nextPageToken'];

    var list = mapa['items'];

    return list.map<Video>((v) => Video.fromMap(v)).toList();
  }
}
