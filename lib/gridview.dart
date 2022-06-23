// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
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
          title: (channel.length < 20)
            ? Text(
                channel[0].categoryname + " Channels",
                //style: TextStyle(color: Colors.black),
              )
            : Text(
                "All Channels  ${channel[0].categoryname}",
                style: const TextStyle(
                  //color: Colors.black
                ),
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
      body: GridView.count(
        primary: true,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: List.generate(channel.length, (index) {
          ads['myBannerGrid$index'] = BannerAd(
            adUnitId: 'ca-app-pub-3940256099942544/6300978111',
            size: AdSize.largeBanner,
            request: const AdRequest(),
            listener: BannerAdListener(
              onAdClosed: (ad) => ad.dispose(),
              onAdFailedToLoad: (ad,e){
                // print('bb$e');
              },
              onAdLoaded: (Ad ad) {
                setState(() {
                  isloading=false;
                });
                // print('qq $isloading');
              },
            ),
          );
          ads['myBannerGrid$index'].load();
          return (index % 4 == 1)
            ? Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Provider.of<ThemeNotifier>(context).getTheme().cardColor,
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
                        child: AdWidget(ad: ads['myBannerGrid$index'],)
                      ),
                      const SizedBox(height: 5,),
                      Text(
                          'Amr TV',
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
              ],
            )
            : InkWell(
                onTap: () async {
                  int i = await load();
                  if (channel[index].channelurl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.purpleAccent[800],
                      behavior: SnackBarBehavior.floating,
                      //width: MediaQuery.of(context).size.width*0.5,
                      elevation: 20.0,
                      content: const Text(
                        "The channel is not live now, try again later",
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 5),
                    ));
                  } 
                  else {
                    if (i >= 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(name: 'youtube player'),
                              builder: (context) => LiveTvPlayer(
                                channel: channel[index],
                              ))).whenComplete(() {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                      });
                    } 
                    // else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         backgroundColor: Colors.blueGrey[800],
                    //         elevation: 24.0,
                    //         title: const Text(
                    //           "You don't have enough coins to watch TV",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         content: Container(
                    //           width: width * 0.5,
                    //           height: height * 0.0,
                    //         ),
                    //         actions: <Widget>[
                    //           Row(
                    //             mainAxisAlignment:
                    //             MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Expanded(
                    //                 child: Container(
                    //                   //width: width*0.25,
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                           color: Colors.white)),
                    //                   child: TextButton(
                    //                     child:const Text(
                    //                       "Cancel",
                    //                       style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                     onPressed: () {
                    //                       //Navigator.of(context, rootNavigator: true).pop();
                    //                       // Navigator.pop(buildContext);
                    //                       // Navigator.pop(buildContext);
                    //                       Navigator.of(context).pop();
                    //                       // Navigator.of(c,rootNavigator: true).pop();
                    //                       //_incrementCounter();// for fixing bug
                    //                       //Navigator.of(context, rootNavigator: true).pop(context);
                    //                       //Navigator.of(context).popUntil((route) => false);
                    //                     },
                    //                   ),
                    //                 ),
                    //               ),
                    //               Expanded(
                    //                 child: Container(
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                           color: Colors.white)),
                    //                   //width: width*0.25,
                    //                   child: TextButton(
                    //                     child: const Text(
                    //                       "Get Free Coin",
                    //                       style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                     onPressed: () {
                    //                       Navigator.of(context).pop();
                    //                       Navigator.push(
                    //                           context,
                    //                           MaterialPageRoute(
                    //                               settings: const RouteSettings(
                    //                                   name: "Reward"),
                    //                               builder: (_) => Rewards()));
                    //                     },
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //         ],
                    //       );
                    //     },
                    //   );
                    // }
                  }
                },
                child: Column(
                  children: [
                    channel[index].channelurl != null
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
                                image: channel[index].channelimage,
                                fadeInDuration: const Duration(seconds: 5),
                                fadeInCurve: Curves.bounceIn,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              channel[index].channelname,
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
                              channel[index].channelname,
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
                  ],
                ),
              );
          }
        ),
      ),
    );
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prf;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }
}
