import 'dart:convert';
import 'package:blur/blur.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
              ? GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: List.generate(snap.data.length, (index) {
                    return InkWell(
                      onTap: () async {
                        int i=await load();
                        if(snap.data[index].channelurl==null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.purpleAccent[800],
                            behavior: SnackBarBehavior.floating,
                            //width: MediaQuery.of(context).size.width*0.5,
                            elevation: 20.0,
                            content: const Text(
                              "The channel is not live now, try again later",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 5),
                          ));
                        }else{
                          if(i>=1){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: RouteSettings(name: 'youtube player'),
                                    builder: (context) => LiveTvPlayer(
                                      channel: snap.data[index],
                                    ))).whenComplete(() {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            });
                          }else{
                            showDialog(
                              context:
                              context,
                              builder:
                                  (context) {
                                return AlertDialog(
                                  backgroundColor:
                                  Colors.blueGrey[
                                  800],
                                  elevation:
                                  24.0,
                                  title: const Text(
                                    "You don't have enough coins to watch TV",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style:
                                    TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                  content: Container(
                                    width: width*0.5,
                                    height: height*0.0,
                                  ),
                                  actions: <
                                      Widget>[
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
                                              child: const Text(
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
                                              child: const Text(
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
                      child: Column( 
                        children: [
                          snap.data[index].channelurl!=null
                          ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Provider.of<ThemeNotifier>(context).getTheme().cardColor,
                                // width: 8
                              ),
                              color: Colors.white12
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                            height: height * 0.12,
                            width: width * 0.28,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                const SizedBox(height: 10,),
                                Container(
                                  height: height*0.065,
                                  width: width * 0.25,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/image/placeHolder.png',
                                    fit: BoxFit.cover,
                                    image: snap.data[index].channelimage,
                                    fadeInDuration: const Duration(seconds: 5),
                                    fadeInCurve: Curves.bounceIn,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  snap.data[index].channelname,
                                  style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: height * 0.0135,
                                      // color: Colors.white60
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Provider.of<ThemeNotifier>(context).getTheme().cardColor,
                                // width: 8
                              ),
                              color: Colors.white12
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                            height: height * 0.12,
                            width: width * 0.28,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Image.asset(
                                    "assets/icon/icon.png",
                                    height: height*0.07,
                                    width: width * 0.25,
                                    fit: BoxFit.fitHeight,).blurred(
                                    blur: 4,
                                    overlay: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline_sharp,
                                          size: height *0.02,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Not Live",
                                          textAlign:TextAlign.center,
                                          style: TextStyle(
                                            fontSize:width * 0.03,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  snap.data[index].channelname,
                                  style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: height * 0.0135,
                                      // color: Colors.white60
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    );
                  })
                )
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
