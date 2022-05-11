
import 'package:flutter/material.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/rewards.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteGridPage extends StatelessWidget {
  final List<ModelChannel> channel;

  const FavoriteGridPage({Key key, this.channel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: MyHome(channel: channel),
    );
  }
}

class MyHome extends StatefulWidget {
  final List<ModelChannel> channel;

  const MyHome({Key key, this.channel}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState(channel);
}

class _MyHomeState extends State<MyHome> {
  final List<ModelChannel> channel;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _MyHomeState(this.channel);

  @override
  Widget build(BuildContext context) {
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
                Navigator.pop(context);
              },
            )
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            ),
        body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(channel.length, (index) {
              return InkWell(
                onTap: () async {
                  int i=await load();
                  if(i>=100){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(name: 'youtube player'),
                            builder: (context) => LiveTvPlayer(
                              channel: channel[index],
                            )));
                  }
                  else{
                    showDialog(context:context,builder:(context) {
                        return AlertDialog(
                          backgroundColor:
                          Colors.blueGrey[800],
                          elevation:24.0,
                          title: const Text(
                            "You don't have enough coins to watch TV",
                            textAlign:TextAlign.center,
                            style:TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:
                              const Text(
                                "Watch Later",
                                style:
                                TextStyle(
                                  fontWeight:FontWeight.bold,
                                  color:Colors.white,
                                ),
                              ),
                              onPressed:
                                  () {
                                //Navigator.of(context, rootNavigator: true).pop();
                                // Navigator.pop(buildContext);
                                // Navigator.pop(buildContext);
                                Navigator.of(context)
                                    .pop();
                                // Navigator.of(c,rootNavigator: true).pop();
                                //_incrementCounter();// for fixing bug

                                //Navigator.of(context, rootNavigator: true).pop(context);
                                //Navigator.of(context).popUntil((route) => false);
                              },
                            ),
                            TextButton(
                              child:
                              const Text(
                                "Watch Now",
                                style:
                                TextStyle(
                                  fontWeight:FontWeight.bold,
                                  color:Colors.white,
                                ),
                              ),
                              onPressed:
                                  () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(settings: const RouteSettings(name: "Reward"), builder: (_) => Rewards()));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    decoration: BoxDecoration(
                      //  borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                        image: NetworkImage(
                          channel[index].channelimage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.black12,
                    width: 200,
                    height: 16,
                    child: Text(
                      channel[index].channelname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              );
            })));
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prefs;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }
}
