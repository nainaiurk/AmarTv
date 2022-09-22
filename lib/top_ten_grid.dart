import 'dart:convert';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:live_tv/Grid_view_widget.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/rewards.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopGridPage extends StatelessWidget {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TopGridPage({Key key}) : super(key: key);

  List<ModelChannel> parseChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ModelChannel>((json) => ModelChannel.fromJson(json))
        .toList();
  }

  Future<List<ModelChannel>> getData(http.Client client) async {
    final response = await http
        .get(Uri.parse('https://amrtvbangla.bmssystems.org/toptenchannels.php'));
    if (response.statusCode == 200) {

      return parseChannel(response.body);
    } else {
      //If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          //backgroundColor: Colors.white,
          title: const Text(
            "Top 10 Channels",
            //style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            // color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
        body: FutureBuilder(
          future: getData(http.Client()),
          builder: (context, snap) {
            return (snap.hasData)
              ? GridViewWidget(channel: snap.data)
              : const Center(
                  child: CircularProgressIndicator(),
                );
          },
        ));
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prefs;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }
}
