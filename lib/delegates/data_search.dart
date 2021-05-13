import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((value) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return Container();
    else {
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (!snapshot.hasData) {
            return Center(
              child: Text('Sem sugestões'),
            );
          } else {
            return ListView(
              children: snapshot.data!
                  .map((v) => ListTile(
                        leading: Icon(Icons.arrow_forward_ios),
                        title: Text(v),
                        onTap: () {
                          close(context, v);
                        },
                      ))
                  .toList(),
            );
          }
        },
      );
    }
  }

  Future<List> suggestions(String search) async {
    http.Response response = await http.get(Uri.parse(
        "https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"));

    if (response.statusCode == 200) {
      var resp = json.decode(response.body);

      return resp[1].map((v) => v[0]).toList();
    } else {
      throw Exception("falha ao carregar api susgestões");
    }
  }
}
