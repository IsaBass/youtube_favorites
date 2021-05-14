import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:yout_favorites/api/video.dart';
import 'package:yout_favorites/blocs/favorites_bloc.dart';
import 'package:yout_favorites/youtubeplayer/youtubeplayer.dart';

class FavoritesScreen extends StatelessWidget {
// YoutubePlayerIFrame(
//     controller: _controller,
//     aspectRatio: 16 / 9,
// ),

  @override
  Widget build(BuildContext context) {
    final _favsBloc = BlocProvider.getBloc<FavoritesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: _favsBloc.outFavs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            List<Video> ls = [];

            snapshot.data!.forEach((key, value) {
              ls.add(value);
            });

            return ListView(
              children: ls
                  .map(
                    (v) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => YoutubeAppDemo(
                                  ids: ls.map((e) => e.id).toList())),
                        );
                      },
                      onLongPress: () {
                        _favsBloc.toggleFavorite(v);
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 50,
                              child: Image.network(v.thumbnail),
                            ),
                            Expanded(
                                child: Text(
                              v.title,
                              maxLines: 2,
                            )),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
