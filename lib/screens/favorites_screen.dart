import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:yout_favorites/api/video.dart';
import 'package:yout_favorites/blocs/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  final _favsBloc = BlocProvider.getBloc<FavoritesBloc>();

// YoutubePlayerIFrame(
//     controller: _controller,
//     aspectRatio: 16 / 9,
// ),

  @override
  Widget build(BuildContext context) {
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
                        //TODO: CHAMA VIDEO PLAY
                        _favsBloc.youtController.load(v.id);
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
                            Expanded(child: Text(v.title)),
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
