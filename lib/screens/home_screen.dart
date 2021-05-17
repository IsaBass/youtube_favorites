import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:yout_favorites/api/video.dart';
import 'package:yout_favorites/blocs/favorites_bloc.dart';
import 'package:yout_favorites/blocs/videos_bloc.dart';
import 'package:yout_favorites/delegates/data_search.dart';
import 'package:yout_favorites/screens/favorites_screen.dart';
import 'package:yout_favorites/screens/widgets/video_tile.dart';

class HomeScreen extends StatelessWidget {
  ////

  @override
  Widget build(BuildContext context) {
    //
    final _favBloc = BlocProvider.getBloc<FavoritesBloc>();
    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black87,
        elevation: 0,
        //leadingWidth: 200,
        title: Container(
          height: 60,
          child: Image.asset(
            'images/logo3.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          StreamBuilder<Map<String, Video>>(
            stream: _favBloc.outFavs,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Text('${snapshot.data!.length}'),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var resp =
                    await showSearch(context: context, delegate: DataSearch());
                print(resp);
                if (resp != "") {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(resp);
                }
              }),
        ],
      ),
      body: Container(
        child: StreamBuilder<List<Video>>(
          stream: BlocProvider.getBloc<VideosBloc>().outVideos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("sem dados"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data!.length)
                  return VideoTile(video: snapshot.data![index]);
                else if (index > 1) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add("");
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text("sem dados"));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
