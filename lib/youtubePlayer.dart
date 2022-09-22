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
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState(channel);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.channel);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Favorite>> f;
  // int _counter = 0;
  bool icon = false;
  ModelChannel channel;
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool _onFullScreen = false;
  bool delay = false;
  String channelId='';
  bool lockVideo = false;
  // bool opacity = false;
  //double _volume = 100;
  //bool _muted = false;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
  // _incrementCounter() async {
  //   SharedPreferences preferences = await _prefs;
  //   setState(() {
  //     _counter = (preferences.getInt('counter') ?? 0) + 1;
  //     preferences.setInt('counter', _counter);
  //   });
  // }
  // Future<int> check() async {
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
//         content:  Text(
//           "Please try again after some time!",
//           textAlign: TextAlign.center,
//         ),
//         duration:  Duration(seconds: 5),
//       ));
//     }
//   }
  // void initiateAd() {
  //   // print('init');
  //   interstitialAd = InterstitialAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/8691691433',
  //     request:  AdRequest(),
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
// setToZero() async {
  //   SharedPreferences preferences = await _prefs;
  //   setState(() {
  //     _counter = 1;
  //     preferences.setInt('counter', _counter);
  //   });
  // }

@override
  void initState() {
    super.initState();
    lockVideo = false;
    loadImage();
    channelController.getChannels(widget.channel);
    _videoMetaData =  const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    //  a= await DatabaseHelper.instance.checkChannel(channel.channelid);
    //  return a;
    // }
    // print("LESGH F${channelController.allTVChannelCategory.length}");
  }

  final ChannelController channelController = Get.put(ChannelController());


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  loadImage() {
    // print('load');
    Future.delayed(const  Duration(seconds: 1), () {
      // print('after5');
      setState(() {
        delay = true;
      });
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
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          // controlsVisibleAtStart: true,
          hideControls: false,
          disableDragSeek: lockVideo,
          loop: false,
          isLive: true,
          forceHD: false,
        ),
      )..addListener(() {listener();});
      // _playerState = PlayerState.unknown;
      //loadImage();
      removeImage();
    });
    print(lockVideo);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

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

  void _launchURL() async => await canLaunch(pageLink)
      ? await launch(pageLink)
      : throw 'Could not launchs $pageLink';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          YoutubePlayerBuilder(
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeLeft]);
                _onFullScreen = true;
            },
            onExitFullScreen: () {
              // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
              //SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                _onFullScreen = false;
            },
            player: YoutubePlayer(
              controller: _controller,
              controlsTimeOut: lockVideo==false? const Duration(seconds: 3): const Duration(seconds: -1),
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
                    leading: lockVideo == false? IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.white,
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true).pop(context);
                      },
                    ): null
                  ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    delay
                    ? player
                    : Image.asset(
                      "assets/image/delay.jpg",
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red[200], width: 1.0)
                      ),
                      width: MediaQuery.of(context).size.width,
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
                            icon: Image.asset(
                              'assets/icon/mess3.png',
                              color: Colors.red,
                              height: 25,
                            )
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
                    Container(
                      margin:   const EdgeInsets.only(left: 15,top: 15),
                      child:  const Text('Watch More',style: TextStyle(fontSize: 20),),
                    ),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding:  const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: channelController.allTVChannelCategory.length,
                        clipBehavior: Clip.antiAlias,
                        separatorBuilder: (BuildContext context, int index) {
                          return  const SizedBox(width: 20,);
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {    
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
                                channelController.allTVChannelCategory[index].channelimage !=null
                                  ? CircleAvatar(
                                    backgroundColor: Colors.red[100],
                                    radius: 45,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.fitHeight,
                                        imageUrl: channelController.allTVChannelCategory[index].channelimage,
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.contain),
                                          ),
                                        ),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:  [
                                              const Icon(Icons.error),
                                              Center(child: Text(channelController.allTVChannelCategory[index].channelname,textAlign: TextAlign.center,),),
                                            ],
                                        ),
                                      ),
                                  )
                                  : Container(),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          _onFullScreen == true
          ? Positioned(
            top: height*0.105,
            right: width*0.03,
            child:IconButton(
              onPressed: (){
                setState(() {
                  // controller.lock();
                  // controller.lockVideo.isFalse? controller.lock():controller.unlock();
                  lockVideo = !lockVideo;
                  // opacity = false;
                  // loadImage();
                  print(lockVideo);
                });
              }, 
              icon: lockVideo==false?   const Icon(Icons.lock_outline):   const Icon(Icons.lock_open)
            ),
          )
          : const SizedBox(height: 0,)
        ],
      ),
    );
  }
}