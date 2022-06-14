// ignore_for_file: must_be_immutable, file_names, prefer_final_fields, sized_box_for_whitespace

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keframe/keframe.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:provider/provider.dart';
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

  Future<void> _sendChannelInfo(ModelChannel modelChannel) async {
    // await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
    //   "Channel_Name": modelChannel.channelname,
    // });
    //await a.logTutorialBegin();
    //print(modelChannel.channelname);
  }

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

  void watchVideo(int index) async {
    if (loadAd == true) {
      await interstitialAd.show().whenComplete(() {
        // print('kik os ${sortedChannel[index].channelurl}');
        Navigator.push(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: 'youtube player'),
              builder: (context) => LiveTvPlayer(
                    channel: sortedChannel[index],
                  )),
        ).whenComplete(() {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        });

        _sendChannelInfo(sortedChannel[index]);
      });
    } else {
      //print('wait');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.yellow[800],
//        behavior: SnackBarBehavior.floating,
        //width: MediaQuery.of(context).size.width*0.5,
        //elevation: 20.0,
        content: const Text(
          "Please try again after some time!",
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 5),
      ));
    }
  }

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
              itemExtent: width * 0.28,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics (),
              scrollDirection: Axis.horizontal,
              // addAutomaticKeepAlives: true,
              // itemCount: sortedChannel.length<7? sortedChannel.length : sortedChannel.length+adCount,
              itemCount: sortedChannel.length,
              itemBuilder: (BuildContext context, int index) {
                ads['myBanner$index'] = BannerAd(
                  adUnitId: 'ca-app-pub-3940256099942544/6300978111',
                  size: AdSize.mediumRectangle,
                  request: const AdRequest(),
                  listener: BannerAdListener(
                    onAdClosed: (ad) => ad.dispose(),
                  ),
                );
                ads['myBanner$index'].load();
                return (index % 3 != 2)
                ? InkWell(
                    onTap: () async {
                      // if (index == 5) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       settings:
                      //           const RouteSettings(name: 'Grid View'),
                      //       builder: (context) => GridPage(
                      //         channel: sortedChannel,
                      //       )
                      //     )
                      //   );
                      // } 
                      // else {
                      //   if (sortedChannel[index].channelurl == null) {
                      //     ScaffoldMessenger.of(context)
                      //         .showSnackBar(SnackBar(
                      //       backgroundColor: Colors.purpleAccent[800],
                      //       behavior: SnackBarBehavior.floating,
                      //       //width: MediaQuery.of(context).size.width*0.5,
                      //       elevation: 20.0,
                      //       content: const Text(
                      //         "The channel is not live now, try again later",
                      //         textAlign: TextAlign.center,
                      //       ),
                      //       duration: const Duration(seconds: 5),
                      //     ));
                      //   } 
                      //   else {
                      //     //Navigator.push( context, MaterialPageRoute( builder: (context) => SecondPage()), ).then((value) => setState(() {}));
                      //     int i = await load();
                      //     print('befores ${channel.length}');
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           settings: const RouteSettings(
                      //               name: 'youtube player'),
                      //           builder: (context) => LiveTvPlayer(
                      //                 channel: sortedChannel[index],
                      //               )),
                      //     ).whenComplete(() {
                      //       SystemChrome.setPreferredOrientations(
                      //           [DeviceOrientation.portraitUp]);
                      //     });
                      //     _sendChannelInfo(sortedChannel[index]);
                      //   }
                      // }
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
                        //Navigator.push( context, MaterialPageRoute( builder: (context) => SecondPage()), ).then((value) => setState(() {}));
                        // int i = await load();
                        // print('befores ${channel.length}');
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
                        _sendChannelInfo(sortedChannel[index]);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
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
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(height: 3,),
                              sortedChannel[index].channelurl !=null
                                ? 
                                CachedNetworkImage(
                                  height: height*0.08,
                                  width: width * 0.25,
                                  fit: BoxFit.fitHeight,
                                  imageUrl: sortedChannel[index].channelimage,
                                  placeholder: (context, url) => const Image(image: AssetImage('assets/image/placeHolder.png')),
                                )
                                // FadeInImage.assetNetwork(
                                //     placeholder:'assets/image/placeHolder.png',
                                //     image: sortedChannel[index].channelimage,
                                //     height: height*0.08,
                                //     width: width * 0.25,
                                //     fit: BoxFit.fitHeight,
                                //     fadeInDuration:const Duration(seconds: 5),
                                //     fadeInCurve: Curves.bounceIn,
                                //   )
                                : Padding(
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
                              // (index == 5)
                              //   ? Blur(
                              //       blur: 2,
                              //       child: Container(
                              //         color: Colors.black12,
                              //         //width: 200,
                              //         //height: 25,
                              //         child: Text(
                              //           sortedChannel[index].channelname,
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: height * 0.025),
                              //           textAlign: TextAlign.center,
                              //         ),
                              //       ),
                              //     )
                              //   : 
                              Text(
                                sortedChannel[index].channelname,
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: height * 0.0135,
                                    // color: Colors.white60
                                  ),
                                textAlign: TextAlign.center,
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
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
                                child: AdWidget(ad: ads['myBanner$index'],)
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
                          // margin: EdgeInsets.symmetric(
                          // vertical: 00.0, horizontal: 3.0),
                          // padding: const EdgeInsets.only(bottom: 50),
                          // clipBehavior: Clip.antiAlias,
                        ),
                    ],
                  );
                
                              },
              // separatorBuilder: (BuildContext context, int index) {
              //   return (index % 3 == 1)
              //     ? Row(
              //       children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             border: Border.all(
              //               color: Colors.white38,
              //               // width: 8
              //             ),
              //             color: Colors.white12
              //           ),
              //           margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
              //           height: height * 0.12,
              //           width: width * 0.28,
              //           alignment: Alignment.topCenter,
              //           child: Column(
              //             children: [
              //               const SizedBox(height: 10,),
              //               Container(
              //                 height: height*0.065,
              //                 width: width * 0.25,
              //                 child: AdWidget(ad: ads['myBanner$index'],)
              //               ),
              //               const SizedBox(height: 5,),
              //               Text(
              //                   'Amr TV',
              //                   style: TextStyle(
              //                       //fontWeight: FontWeight.bold,
              //                       fontSize: height * 0.0135,
              //                       color: Colors.white60
              //                     ),
              //                   textAlign: TextAlign.center,
              //                 ),
              //             ],
              //           ),
              //           // margin: EdgeInsets.symmetric(
              //           // vertical: 00.0, horizontal: 3.0),
              //           // padding: const EdgeInsets.only(bottom: 50),
              //           // clipBehavior: Clip.antiAlias,
              //         ),
              //       ],
              //     )
              //     : const Divider();
              // },
            ),
          ),
        );
  }
}