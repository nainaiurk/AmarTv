// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:live_tv/controller/channelController.dart';
import 'helper/database_helper_favorite.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/model/modelFavorite.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveTvPlayer extends StatelessWidget {
  final ModelChannel channel;

  const LiveTvPlayer({Key key, this.channel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        channel: channel,
      ),
      theme: themeNotifier.getTheme(),
      // navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
    );
  }
}

/// Homepage
class MyHomePage extends StatefulWidget {
  final ModelChannel channel;

  const MyHomePage({Key key, this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(channel);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.channel);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Favorite>> f;

  int _counter = 0;

  bool icon = false;

  ModelChannel channel;

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;

  PlayerState _playerState;

  YoutubeMetaData _videoMetaData;

  //double _volume = 100;
  //bool _muted = false;
  bool _isPlayerReady = false;
  bool delay = false;

  // final List<String> _ids = [
  //   'nPt8bK2gbaU',
  //   'gQDByCdjUXw',
  //   'iLnmTe5Q2Qw',
  //   '_WoCV4c6XOE',
  //   'KmzdUe0RSJo',
  //   '6jZDSSZZxjQ',
  //   'p2lYr3vM_1w',
  //   '7QUtEmBT_-w',
  //   '34_PXCzGw1M',
  // ];

  // _loadCounter() async {
  //   final SharedPreferences prefs = await _prefs;
  //   setState(() {
  //     _counter = (prefs.getInt("Rcounter"));
  //   });
  //   if (_counter == 0) {
  //     // print('counter>0');
  //     // initiateAd();
  //   }
  //   // print('lol  $_counter');
  // }

  setToZero() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      _counter = 1;
      preferences.setInt('counter', _counter);
    });
  }

  // _incrementCounter() async {
  //   SharedPreferences preferences = await _prefs;
  //   setState(() {
  //     _counter = (preferences.getInt('counter') ?? 0) + 1;
  //     preferences.setInt('counter', _counter);
  //   });
  // }

  // Future<int> check() async {
  //  a= await DatabaseHelper.instance.checkChannel(channel.channelid);
  //  return a;
  // }

  String channelId='';

  loadImage() {
    // print('load');
    Future.delayed(const  Duration(seconds: 1), () {
      // print('after5');
      setState(() {
        delay = true;
      });
      // _loadCounter();
      // if(_counter != null && _counter % 5 == 0){
      //   _controller.pause();
      // }
      // loadImage();
      // decrement();
      f = DatabaseHelper.instance.retrieveFavorite();
      f.then((value) {
        if (value.isNotEmpty) {
          value.forEach((element) {
            if (element.channelName == channel.channelname) {
              setState(() {
                icon = true;
              });
            }
          });
        }
      });

      setState(() {
        channelId=channel.channelurl;
      });

      _controller = YoutubePlayerController(
        initialVideoId: channelId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          hideControls: false,
          // startAt: 0,
          // controlsVisibleAtStart: true,
          //hideControls: false,
          disableDragSeek: false,
          loop: false,
          isLive: true,
          forceHD: false,
          // enableCaption: false,
        ),
      );
      // _playerState = PlayerState.unknown;
      //loadImage();
      removeImage();
    });
  }

  // InterstitialAd interstitialAd;
  // bool loadAd = true;

//   void watchAd() async {
//     if (loadAd == true) {
//       await interstitialAd.show();
//       // print('WATCHADs');
//     } else {
//       //print('wait');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.yellow[800],
// //        behavior: SnackBarBehavior.floating,
//         //width: MediaQuery.of(context).size.width*0.5,
//         //elevation: 20.0,
//         content: const Text(
//           "Please try again after some time!",
//           textAlign: TextAlign.center,
//         ),
//         duration: const Duration(seconds: 5),
//       ));
//     }
//   }

  // void initiateAd() {
  //   // print('init');
  //   interstitialAd = InterstitialAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/8691691433',
  //     request: const AdRequest(),
  //     listener: AdListener(
  //       onAdLoaded: (Ad ad) {
  //         setState(() {
  //           loadAd = true;
  //         });
  //         interstitialAd.show();
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         ad.dispose();
  //         // print('Ad failed to load: $error');
  //       },
  //       onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
  //         ad.dispose();
  //         ad.load();
  //       },
  //     ),
  //   );

  //   // print('initss');
  //   interstitialAd.load();
  // }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  // void decrement() async {
  //   SharedPreferences preference = await _prefs;
  //   int reward = (preference.getInt('Rcounter') ?? 10) - 1;
  //   if (reward < 1) {
  //     preference.setInt('Rcounter', 0);
  //   } else {
  //     preference.setInt('Rcounter', reward);
  //   }
  //   print('hihih');
  //   print(reward);
  // }

  void removeImage() {
    setState(() {
      // print('listeners');
      delay = true;
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  Future<void> enablePip() async {
    final enabledSuccessfully = await Floating.enablePip();
    // print('PiP enabled? $enabledSuccessfully');
  }

  var pageLink = "https://m.me/100453655696187";

  void _launchURL() async => await canLaunchUrl(Uri.parse(pageLink))
      ? await launchUrl(Uri.parse(pageLink))
      : throw 'Could not launchs $pageLink';

  final ChannelController channelController = Get.put(ChannelController());

  @override
  void initState() {
    super.initState();
    loadImage();
    channelController.getChannels(widget.channel);
    // print("LESGH F${channelController.allTVChannelCategory.length}");
  }

  @override
  void dispose() {
    // _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      },
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        //SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      player: YoutubePlayer(
        controller: _controller,
        //showVideoProgressIndicator: true,
        //progressIndicatorColor: Colors.blueAccent,
        topActions: const <Widget>[
          // const SizedBox(width: 8.0),
          // Expanded(
          //   child: Text(
          //     _controller.metadata.title,
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 18.0,
          //     ),
          //     overflow: TextOverflow.ellipsis,
          //     maxLines: 1,
          //   ),
          // ),
        ],

        onReady: () {
          setState(() {
            _isPlayerReady = true;
          });
        },
        onEnded: (data) {
          // _controller
          //     .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          // _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                channel.channelname + " Live",
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Colors.white,
                onPressed: () {
                  //Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
              )),
          body: Column(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            // clipBehavior: Clip.antiAlias,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              delay
                ? player
                : Container(
                    //height: MediaQuery.of(context).size.height,
                    //width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/image/delay.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
              Container(
                margin: const EdgeInsets.all(5),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red[200], width: 1.0)
                ),
                width: MediaQuery.of(context).size.width,
                //color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        channel.channelname,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      splashRadius: 20,
                      splashColor: Colors.blue,
                      onPressed: _launchURL,
                      icon: const Icon(
                        Icons.message_outlined,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      splashRadius: 20,
                      splashColor: Colors.blue,
                      onPressed:
                          //()
                          //                 {
                          // PIPView.of(context).presentBelow(Settings());
                          // },
                          enablePip,
                      icon: const Icon(
                        Icons.picture_in_picture,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      splashRadius: 20,
                      splashColor: Colors.blue,
                      onPressed: () async {
                        if (icon) {
                          DatabaseHelper.instance
                              .delete(channel.channelname)
                              .whenComplete(() {
                            setState(() {
                              icon = false;
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Deleted from Favorites"),
                              duration: Duration(seconds: 3),
                            )
                          );
                        } 
                        else {
                          await DatabaseHelper.instance.insert({
                            DatabaseHelper.columnChannelName:
                                channel.channelname,
                            DatabaseHelper.columnChannelCategory:
                                channel.categoryname,
                            DatabaseHelper.columnChannelId: channel.channelid,
                            DatabaseHelper.columnChannelType:
                                channel.channeltype,
                            DatabaseHelper.columnChannelUrl: channel.channelurl,
                            DatabaseHelper.columnChannelImage:
                                channel.channelimage,
                          });
                          setState(() {
                            icon = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Added to Favorites"),
                              duration: Duration(seconds: 3),
                            )
                          );
                        }
                      },
                      icon: !icon
                          ? const Icon(
                              Icons.add,
                              color: Colors.red,
                              size: 25,
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              ),
              // ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemCount: allTVChannelCategory.length,
              //     clipBehavior: Clip.antiAlias,
              //     itemBuilder: (context, index) {
              //       // print('pp');
              //       // print(allTVChannelCategory.length);
              //       return Row(
              //         children: [
              //           Image.network("${allTVChannelCategory[index].channelimage}",scale: 5,),
              //           Text('lol'),
              //         ],
              //       );
              //     }),
              // Container(
              //     height: 500,
              //     clipBehavior: Clip.antiAlias,
              //     decoration: BoxDecoration(),
              //     child: ListView.builder(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemBuilder: (context, index) {
              //           return Text('lol');
              //         })
              //   //           ListView(
              //   //             children: [ExpansionTile(
              //   //               children:
              //   //                 List.generate(200, (index) =>  Text('lol')),
              //   //               title: Text('lol'),
              //   //             ),
              //   // ],
              //   //           ),
              // ),

              // ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemCount: allTVChannelCategory.length,
              //     clipBehavior: Clip.antiAlias,
              //     itemBuilder: (context, index) {
              //       // print('pp');
              //       // print(allTVChannelCategory.length);
              //       return Row(
              //         children: [
              //           Image.network("${allTVChannelCategory[index].channelimage}",scale: 5,),
              //           Text('lol'),
              //         ],
              //       );
              //     }),
              Container(
                margin: const  EdgeInsets.only(left: 15,top: 15),
                child: const Text('Watch More',style: TextStyle(fontSize: 20),),),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: channelController.allTVChannelCategory.length,
                  clipBehavior: Clip.antiAlias,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 20,);
                  },
                  itemBuilder: (context, index) {
                    // print('pp');
                    // print(allTVChannelCategory.length);
                    return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       settings:
                        //       RouteSettings(name: 'youtube player'),
                        //       builder: (context) => LiveTvPlayer(
                        //         allchannel: channelController
                        //             .allChannelGet,
                        //         channel: channelController
                        //             .allTVChannelCategory[index],
                        //       )),
                        // ).whenComplete(() {
                        //   SystemChrome.setPreferredOrientations(
                        //       [DeviceOrientation.portraitUp]);
                        // });

                        setState(() {
                          channel = channelController
                              .allTVChannelCategory[index];

                          _controller.load(channelController
                              .allTVChannelCategory[index].channelurl);
                        });

                        channelController.getChannels(channelController.allTVChannelCategory[index]);
                        // _loadCounter();
                        // decrement();
                      },
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.white38,
                                // width: 8
                              ),
                              color: Colors.white12
                            ),
                            height: height * 0.12,
                            width: width * 0.27,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                channelController.allTVChannelCategory[index].channelimage !=null
                                  ? CachedNetworkImage(
                                      height: height*0.08,
                                      width: width * 0.25,
                                      fit: BoxFit.fitHeight,
                                      imageUrl: channelController.allTVChannelCategory[index].channelimage,
                                      placeholder: (context, url) =>const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.error),
                                            Center(child: Text('No Image Found',textAlign: TextAlign.center,),),
                                          ],
                                        ),
                                    )
                                  : Container(),
                                Text(
                                  channelController.allTVChannelCategory[index].channelname,
                                  style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: height * 0.0135,
                                      color: Colors.white60
                                    ),
                                  textAlign: TextAlign.center,
                                ),

                                // Image.network("${allTVChannelCategory[index].channelimage}",scale: 5,),
                                // Text('lol'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //       scrollDirection: Axis.vertical,
              //       shrinkWrap: true,
              //       padding: EdgeInsets.symmetric(horizontal: 15),
              //       itemCount: channelController.allTVChannelCategory.length,
              //       clipBehavior: Clip.antiAlias,
              //       itemBuilder: (context, index) {
              //
              //         // print('pp');
              //         // print(allTVChannelCategory.length);
              //         return InkWell(
              //           onTap: (){
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   settings: RouteSettings(
              //                       name: 'youtube player'),
              //                   builder: (context) => LiveTvPlayer(
              //                     allchannel:channelController.allChannelGet.value,
              //                     channel: channelController.allTVChannelCategory[index],
              //                   )),
              //             ).whenComplete(() {
              //               SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              //             });
              //           },
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               channelController.allTVChannelCategory[index].channelimage!=null?CachedNetworkImage(
              //                 width: 150,
              //                 height: 150,
              //                 imageUrl: channelController.allTVChannelCategory[index].channelimage,
              //                 placeholder: (context,url) => Center(child: CircularProgressIndicator()),
              //                 errorWidget: (context,url,error) => Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     new Icon(Icons.error),
              //                     Text('No Image Found'),
              //                   ],
              //                 ),
              //               ):Container(),
              //
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('${channelController.allTVChannelCategory[index].categoryname}',style: TextStyle(fontSize: 14),),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Text('${channelController.allTVChannelCategory[index].channelname}',style: TextStyle(fontSize: 18),),
              //                 ],
              //               )
              //
              //               // Image.network("${allTVChannelCategory[index].channelimage}",scale: 5,),
              //               // Text('lol'),
              //             ],
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        );
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: Image(
        //     image: AssetImage("assets/image/delay.jpg"),
        //     fit: BoxFit.cover,
        //     // height: MediaQuery.of(context).size.width * 0.7,
        //     // width: MediaQuery.of(context).size.width * 0.7,
        //   ),
        // );
      },
    );
  }

// Widget _text(String title, String value) {
//   return RichText(
//     text: TextSpan(
//       text: '$title : ',
//       style: const TextStyle(
//         color: Colors.blueAccent,
//         fontWeight: FontWeight.bold,
//       ),
//       children: [
//         TextSpan(
//           text: value ?? '',
//           style: const TextStyle(
//             color: Colors.blueAccent,
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Color _getStateColor(PlayerState state) {
//   switch (state) {
//     case PlayerState.unknown:
//       return Colors.grey[700];
//     case PlayerState.unStarted:
//       return Colors.pink;
//     case PlayerState.ended:
//       return Colors.red;
//     case PlayerState.playing:
//       return Colors.blueAccent;
//     case PlayerState.paused:
//       return Colors.orange;
//     case PlayerState.buffering:
//       return Colors.yellow;
//     case PlayerState.cued:
//       return Colors.blue[900];
//     default:
//       return Colors.blue;
//   }
// }

//Widget get _space => const SizedBox(height: 10);

// Widget _loadCueButton(String action) {
//   return Expanded(
//     child: MaterialButton(
//       color: Colors.blueAccent,
//       onPressed: _isPlayerReady
//           ? () {
//               if (_idController.text.isNotEmpty) {
//                 var id = YoutubePlayer.convertUrlToId(
//                   _idController.text,
//                 );
//                 if (action == 'LOAD') _controller.load(id);
//                 if (action == 'CUE') _controller.cue(id);
//                 FocusScope.of(context).requestFocus(FocusNode());
//               } else {
//                 _showSnackBar('Source can\'t be empty!');
//               }
//             }
//           : null,
//       disabledColor: Colors.grey,
//       disabledTextColor: Colors.black,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14.0),
//         child: Text(
//           action,
//           style: const TextStyle(
//             fontSize: 18.0,
//             color: Colors.white,
//             fontWeight: FontWeight.w300,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     ),
//   );
// }

}
