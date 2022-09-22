// ignore_for_file: avoid_function_literals_in_foreach_calls, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/Grid_view_widget.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/model/modelFavorite.dart';
import 'package:live_tv/rewards.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/database_helper_favorite.dart';

class FavoriteGrid extends StatelessWidget {
  const FavoriteGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<ModelChannel> channel = [];
  List<Favorite> fChannel = [];
  bool hasData = false;
  final Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  List<ModelChannel> converts(List<Favorite> s) {
    List<ModelChannel> temp = [];
    s.forEach((element) {
      ModelChannel modelTemp = ModelChannel(
          the0: element.channelId,
          the1: element.channelName,
          the2: element.channelType,
          the3: element.channelCategory,
          the4: element.channelImage,
          the6: element.channelUrl,
          channelid: element.channelId,
          categoryname: element.channelCategory,
          channeltype: element.channelType,
          channelname: element.channelName,
          channelimage: element.channelImage,
          channelurl: element.channelUrl);
      temp.add(modelTemp);
    });
    return temp;
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prf;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }

  getList() async {
    var list = await DatabaseHelper.instance.retrieveFavorite();
    setState(() {
      fChannel = list;
    });
    //.then((value) => fChannel = value);
    // print(fChannel);
    if (fChannel.isNotEmpty) {
      setState(() {
        channel = converts(fChannel);
        hasData = true;
      });
    }
    // print(channel.length);
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          //backgroundColor: Colors.white,
          title: const Text(
            "Favorite Channels",
            //style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            //color: Colors.black,
            onPressed: () {
              //Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop(context);
            },
          )
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
      body: (hasData == true)
        ? GridViewWidget(channel: channel)
        : const Center(
            child: Text("You haven't added any favorites yet!"),
          ),
    );
  }
}
