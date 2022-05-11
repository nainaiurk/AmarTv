import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/model/modelFavorite.dart';
import 'package:live_tv/rewards.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/database_helper_favorite.dart';

class FavoriteGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<ModelChannel> channel = [];
  List<Favorite> fChannel = [];
  bool hasData = false;
  Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  List<ModelChannel> converts(List<Favorite> s) {
    List<ModelChannel> temp = [];
    s.forEach((element) {
      ModelChannel modelTemp = new ModelChannel(
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
    // TODO: implement initState
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
          title: Text(
            "Favorite Channels",
            //style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
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
          ? Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                GridView.count(
                  primary: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: List.generate(channel.length, (index) {
                    return InkWell(
                      onTap: () async {
                        int i = await load();
                        if(channel[index].channelurl==null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.purpleAccent[800],
                            behavior: SnackBarBehavior.floating,
                            //width: MediaQuery.of(context).size.width*0.5,
                            elevation: 20.0,
                            content: Text(
                              "The channel is not live now, try again later",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 5),
                          ));
                        }else{
                          if (i >= 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings:
                                    RouteSettings(name: 'youtube player'),
                                    builder: (context) => LiveTvPlayer(
                                      channel: channel[index],
                                    ))).whenComplete(() {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.blueGrey[800],
                                  elevation: 24.0,
                                  title: Text(
                                    "You don't have enough coins to watch TV",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: Container(
                                    width: width*0.5,
                                    height: height*0.0,
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            //width: width*0.25,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white)
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                //Navigator.of(context, rootNavigator: true).pop();
                                                // Navigator.pop(buildContext);
                                                // Navigator.pop(buildContext);
                                                Navigator.of(context).pop();
                                                // Navigator.of(c,rootNavigator: true).pop();
                                                //_incrementCounter();// for fixing bug

                                                //Navigator.of(context, rootNavigator: true).pop(context);
                                                //Navigator.of(context).popUntil((route) => false);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white)
                                            ),
                                            //width: width*0.25,
                                            child: TextButton(
                                              child: Text(
                                                "Get Free Coin",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings:
                                                        RouteSettings(name: "Reward"),
                                                        builder: (_) => Rewards()));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Column(children: [
                        Container(
                          height: height*0.08,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/image/placeHolder.png',
                            image: channel[index].channelimage,
                            fadeInDuration: Duration(seconds: 5),
                            fadeInCurve: Curves.bounceIn,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            //  borderRadius: BorderRadius.all(Radius.circular(12)),
                            // image: DecorationImage(
                            //   image: NetworkImage(
                            //     channel[index].channelimage,
                            //   ),
                            //fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          //color: Colors.black12,
                         // width: 200,
                          //height: 14,
                          child: Text(
                            channel[index].channelname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height*0.02,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                    );
                  }),
                ),
              ],
            )
          : Center(
              child: Text("You haven't added any favorites yet!"),
            ),
    );
  }
}
