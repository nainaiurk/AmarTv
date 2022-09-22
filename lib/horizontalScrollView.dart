// ignore_for_file: must_be_immutable, file_names, prefer_final_fields, sized_box_for_whitespace

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keframe/keframe.dart';

import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scroll extends StatefulWidget {
  final List<ModelChannel> channel;
  final List<ModelChannel> allChannels;

  // final Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  const Scroll({Key key, this.channel, this.allChannels}) : super(key: key);

  @override
  _ScrollState createState() => _ScrollState(channel, allChannels);
}

class _ScrollState extends State<Scroll> {
  final List<ModelChannel> channel;

  final List<ModelChannel> allChannels;

  List<ModelChannel> sortedChannel;
  Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  Future<int> load() async {
    final SharedPreferences prefs = await _prf;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }

  // Future<void> _sendChannelInfo(ModelChannel modelChannel) async {
  //   // await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
  //   //   "Channel_Name": modelChannel.channelname,
  //   // });
  //   //await a.logTutorialBegin();
  //   //print(modelChannel.channelname);
  // }

  _ScrollState(this.channel, this.allChannels);

  List<ModelChannel> sortChannel(List<ModelChannel> channel) {
    channel.sort((a, b) => a.channelurl == null
      ? 1
      : b.channelurl == null
          ? -1
          : a.channelurl.compareTo(b.channelurl)
    );
    return channel;
  }

  @override
  void didChangeDependencies() {
    // print('didchange');
    super.didChangeDependencies();
  }

  BannerAd myBanner;
  var all;

  @override
  void initState() {
    sortedChannel = sortChannel(channel);
    // print("${sortedChannel.length} ******************************************");
    //   myBanner = BannerAd(
    //   adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    //   size: AdSize.banner,
    //   request: AdRequest(),
    //   listener:AdListener(
    //     onAdLoaded: (Ad ad) {
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       print('Ad failed to load: $error');
    //     },
    //     onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
    //       print(reward.type);
    //       print(reward.amount);
    //     },
    //   ),
    // );
    // myBanner.load();
    // interstitialAd = InterstitialAd(
    //   adUnitId: 'ca-app-pub-3940256099942544/8691691433',
    //   request: AdRequest(),
    //   listener: AdListener(
    //     onAdLoaded: (Ad ad) {
    //       setState(() {
    //         loadAd = true;
    //       });
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       ad.dispose();
    //       print('Ad failed to load: $error');
    //     },
    //     onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward){
    //
    //     },
    //   ),
    // );
    //   print('init');
    //
    //  interstitialAd.load();
    super.initState();
  }

  InterstitialAd interstitialAd;
  int reward;
  bool loadAd = false;

//   void watchVideo(int index) async {
//     if (loadAd == true) {
//       await interstitialAd.show().whenComplete(() {
//         // print('kik os ${sortedChannel[index].channelurl}');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               settings: const RouteSettings(name: 'youtube player'),
//               builder: (context) => LiveTvPlayer(
//                     channel: sortedChannel[index],
//                   )),
//         ).whenComplete(() {
//           SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//         });

//         _sendChannelInfo(sortedChannel[index]);
//       });
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

  Map<String, BannerAd> ads = <String, BannerAd>{};

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // int adCount = (sortedChannel.length/3).toInt();
    return (channel.isEmpty)
      ? const SizedBox(height: 0.1,)
      : Expanded(
          child: SizeCacheWidget(
            estimateCount: sortedChannel.length*2,
            child: ListView.builder(
              cacheExtent: 100,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics (),
              scrollDirection: Axis.horizontal,
              itemCount: sortedChannel.length,
              itemBuilder: (BuildContext context, int index) {
                // ads['myBanner$index'] = BannerAd(
                //   adUnitId: 'ca-app-pub-3940256099942544/6300978111',
                //   size: AdSize.mediumRectangle,
                //   request: const AdRequest(),
                //   listener: BannerAdListener(
                //     onAdClosed: (ad) => ad.dispose(),
                //   ),
                // );
                // ads['myBanner$index'].load();
                // return (index % 3 != 2)
                // ? 
                return InkWell(
                  onTap: () async {
                    if (sortedChannel[index].channelurl == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.purpleAccent[800],
                          behavior: SnackBarBehavior.floating,
                          //width: MediaQuery.of(context).size.width*0.5,
                          elevation: 20.0,
                          content: const Text(
                            "The channel is not live now, try again later",
                            textAlign: TextAlign.center,
                          ),
                          duration: const Duration(seconds: 5),
                        )
                      );
                    } 
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(
                                name: 'youtube player'),
                            builder: (context) => LiveTvPlayer(
                                  channel: sortedChannel[index],
                                )),
                      ).whenComplete(() {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                      });
                      // _sendChannelInfo(sortedChannel[index]);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: sortedChannel[index].channelurl !=null
                      ? CachedNetworkImage(      
                        fit: BoxFit.fitHeight,
                        imageUrl: sortedChannel[index].channelimage,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                            ),          
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10,10,10,12),
                                child: Text(
                                  sortedChannel[index].channelname,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.black38,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ),
                          ),
                        ),
                        errorWidget: (context,a,dd){
                          return  CircleAvatar(
                            radius: 45,
                            backgroundImage: const AssetImage('assets/image/placeHolder.png'),
                            child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                            ),          
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10,10,10,12),
                                child: Text(
                                  sortedChannel[index].channelname,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.black38,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ),
                          ),
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage('assets/image/placeHolder.png')
                        )
                      )
                      : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 47,
                        child: Image.asset(
                          "assets/icon/icon.png",
                          fit: BoxFit.fitHeight,).blurred(
                          borderRadius:BorderRadius.circular(60),
                          blur: 4,
                          overlay: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              const Icon(
                                Icons.error_outline_sharp,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text(
                                sortedChannel[index].channelname,
                                textAlign:TextAlign.center,
                                style: const TextStyle(
                                  fontSize:12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                );
              },
            ),
          ),
        );
  }
}