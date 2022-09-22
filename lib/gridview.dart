// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:live_tv/Grid_view_widget.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridPage extends StatelessWidget {
  final List<dynamic> channel;

  const GridPage({Key key, this.channel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: MyGrid(channel: channel),
    );
  }
}

class MyGrid extends StatefulWidget {
  final List<dynamic> channel;

  const MyGrid({Key key, this.channel}) : super(key: key);

  @override
  _MyGridState createState() => _MyGridState(channel);
}

class _MyGridState extends State<MyGrid> {
  final List<dynamic> channel;
  final Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  _MyGridState(this.channel);

  @override
  void initState() {
    super.initState();
    sortChannel(channel);
  }

  List<dynamic> sortChannel(List<dynamic> channel) {
    channel.sort((a, b) => a.channelurl == null
        ? 1
        : b.channelurl == null
        ? -1
        : a.channelurl.compareTo(b.channelurl));
    return channel;
  }

  Map<String, BannerAd> ads = <String, BannerAd>{};
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          title: const Text('All Channels'),
          // (channel.length < 20)
          //   ? Text(
          //       channel[0].categoryname + " Channels",
          //       //style: TextStyle(color: Colors.black),
          //     )
          //   : Text(
          //       "All Channels  ${channel[0].categoryname}",
          //       style: const TextStyle(
          //         //color: Colors.black
          //       ),
          //     ),
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
      body: GridViewWidget(channel: channel) 
    );
  }
}