// import 'package:blur/blur.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:live_tv/model/modelChannel.dart';

// import 'package:live_tv/youtubePlayer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'gridview.dart';


// class Scroll extends StatefulWidget {
//   final List<ModelChannel> channel;
//   final List<ModelChannel> allChannels;

//   Future<SharedPreferences> _prf = SharedPreferences.getInstance();
//   Scroll({Key key, this.channel, this.allChannels}) : super(key: key);


//   @override
//   _ScrollState createState() => _ScrollState(channel,allChannels);
// }

// class _ScrollState extends State<Scroll> {
//   final List<ModelChannel> channel;

//   final List<ModelChannel> allChannels;

//   List<ModelChannel> sortedChannel;
//   Future<SharedPreferences> _prf = SharedPreferences.getInstance();

//   Future<int> load() async {
//     final SharedPreferences prefs = await _prf;
//     int i = (prefs.getInt("Rcounter") ?? 10);
//     return i;
//   }

//   Future<void> _sendChannelInfo( ModelChannel modelChannel) async
//   {
//     // await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
//     //   "Channel_Name": modelChannel.channelname,
//     // });
//     //await a.logTutorialBegin();
//     //print(modelChannel.channelname);
//   }

//   _ScrollState(this.channel, this.allChannels);
//   List<ModelChannel> sortChannel(List<ModelChannel> channel){
//     channel.sort((a, b) => a.channelurl==null ? 1: b.channelurl==null? -1 : a.channelurl.compareTo(b.channelurl));
//     return channel;
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies

//     print('didchange');

//     super.didChangeDependencies();
//   }

//   BannerAd myBanner;
//   @override
//   void initState(){
//     // TODO: implement initState

//     sortedChannel=sortChannel(channel);

//     //   myBanner = BannerAd(
//     //   adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//     //   size: AdSize.banner,
//     //   request: AdRequest(),
//     //   listener:AdListener(
//     //     onAdLoaded: (Ad ad) {
//     //     },
//     //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//     //       print('Ad failed to load: $error');
//     //     },
//     //     onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
//     //       print(reward.type);
//     //       print(reward.amount);
//     //     },
//     //   ),
//     // );
//     // myBanner.load();


//     // interstitialAd = InterstitialAd(
//     //   adUnitId: 'ca-app-pub-3940256099942544/8691691433',
//     //   request: AdRequest(),
//     //   listener: AdListener(
//     //     onAdLoaded: (Ad ad) {
//     //       setState(() {
//     //         loadAd = true;
//     //       });
//     //     },
//     //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//     //       ad.dispose();
//     //       print('Ad failed to load: $error');
//     //     },
//     //     onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward){
//     //
//     //     },
//     //   ),
//     // );
//     //   print('init');
//     //
//     //  interstitialAd.load();
//     super.initState();
//   }

//   InterstitialAd interstitialAd;
//   int reward;
//   bool loadAd = false;

//   void watchVideo(int index) async{
//     if (loadAd == true) {
//       await interstitialAd.show().whenComplete(() {

//         print('kik os ${sortedChannel[index].channelurl}');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               settings: RouteSettings(
//                   name: 'youtube player'),
//               builder: (context) => LiveTvPlayer(
// <<<<<<< HEAD
// <<<<<<< HEAD
// <<<<<<< HEAD
// <<<<<<< HEAD
//                 allchannel:allChannels,
//                 channel: sortedChannel[index],
//               )),
// =======
// =======
// >>>>>>> parent of 1e76bb7 (view all grid+ad middle)
// =======
// >>>>>>> parent of 1e76bb7 (view all grid+ad middle)
// =======
// >>>>>>> parent of 1e76bb7 (view all grid+ad middle)
//                     allchannel: allChannels,
//                     channel: sortedChannel[index],
//                   )),
// >>>>>>> parent of 1e76bb7 (view all grid+ad middle)
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
//         content: Text(
//           "Please try again after some time!",
//           textAlign: TextAlign.center,
//         ),
//         duration: Duration(seconds: 5),
//       ));
//     }
//   }

//   Map<String, BannerAd> ads = <String, BannerAd>{};

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return (channel.length == 0)
//         ? SizedBox(
//       height: 0.1,
//     )
//         : Container(
//       height: height * 0.28,
//       child: ListView.separated(
//         //padding: const EdgeInsets.all(8),
//         //shrinkWrap: true,
//           addAutomaticKeepAlives: false,
//           scrollDirection: Axis.horizontal,
//           itemCount: sortedChannel.isEmpty ? 0 : 8,

//           itemBuilder: (BuildContext context, int index) {
//             ads['myBanner$index'] = BannerAd(
//                 adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//                 size: AdSize.largeBanner,
//                 request: AdRequest(),
//                 listener: AdListener(onAdClosed: (ad) => ad.dispose()));
//             ads['myBanner$index'].load();

//             // print('index $index');
//             int temp;
//             if(index%3==1){
//                temp = index;
//                // print('temp');
//                // print(temp);
//             }
//             return (index < 6)
//                 ?
//             Row(
//               children: [
//                 // (index%3==1)?
//                 // // Column(
//                 // //   // mainAxisSize: MainAxisSize.min,
//                 // //     children: [
//                 // //       Container(
//                 // //         margin: EdgeInsets.symmetric(
//                 // //             vertical: 10.0, horizontal: 3.0),
//                 // //         height: height * 0.18,
//                 // //         width: width * 0.5,
//                 // //         child: Image.asset(
//                 // //           'assets/image/placeHolder.png',
//                 // //           fit: BoxFit.cover,
//                 // //         ),
//                 // //       ),
//                 // //       Container(
//                 // //         //color: Colors.black12,
//                 // //         //width: 200,
//                 // //         // height: 25,
//                 // //         child: Text(
//                 // //           'lol',
//                 // //           style: TextStyle(
//                 // //             //fontWeight: FontWeight.bold,
//                 // //               fontSize: height * 0.025),
//                 // //           textAlign: TextAlign.center,
//                 // //         ),
//                 // //       ),
//                 // //     ])
//                 // Container(
//                 //   alignment: Alignment.center,
//                 //   child: AdWidget(ad: ads['myBanner$index']),
//                 //   margin: EdgeInsets.symmetric(
//                 //       vertical: 10.0, horizontal: 3.0),
//                 //   height: height * 0.18,
//                 //   width: width * 0.5,
//                 // )
//                 //     :
//                 // Container(
//                 // ),
//                 InkWell(
//                       onTap: () async {
//                             if (index==5) {
//                                   Navigator.push(
// <<<<<<< HEAD
//                                       context,
//                                       MaterialPageRoute(
//                                           settings:
//                                           RouteSettings(name: 'Grid View'),
//                                           builder: (context) => GridPage(
//                                                 channel: sortedChannel,
//                                           )));

//                             } else {
//                                   if (sortedChannel[index].channelurl == null) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                               backgroundColor: Colors.purpleAccent[800],
//                                               behavior: SnackBarBehavior.floating,
//                                               //width: MediaQuery.of(context).size.width*0.5,
//                                               elevation: 20.0,
//                                               content: Text(
//                                                     "The channel is not live now, try again later",
//                                                     textAlign: TextAlign.center,
//                                               ),
//                                               duration: Duration(seconds: 5),
//                                         ));

//                                   }
//                                   else
//                                   {
//                                         //Navigator.push( context, MaterialPageRoute( builder: (context) => SecondPage()), ).then((value) => setState(() {}));
//                                         int i = await load();
//                                         print('befores ${channel.length}');
//                                         Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   settings: RouteSettings(
//                                                       name: 'youtube player'),
//                                                   builder: (context) => LiveTvPlayer(
//                                                     allchannel:allChannels,
//                                                         channel: sortedChannel[index],
//                                                   )),
//                                         ).whenComplete(() {
//                                               SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//                                         });
//                                         _sendChannelInfo(sortedChannel[index]);
//                                   }
//                             }
//                       },
//                       child: Column(
//                             // mainAxisSize: MainAxisSize.min,
//                           children: [
//                                 Container(
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 10.0, horizontal: 3.0),
//                                     height: height * 0.18,
//                                     width: width * 0.5,
//                                     child: (index == 5)
//                                         ? sortedChannel[index].channelurl != null
//                                         ? ImageBlur.network(
//                                           sortedChannel[index].channelimage,
//                                           scale: 1.0,
//                                           fit: BoxFit.cover,
//                                           //scale: 2.5,
//                                           //height: 200,
//                                           blur: 4,
//                                           overlay: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                                 children: [
// =======
//                                     context,
//                                     MaterialPageRoute(
//                                         settings: RouteSettings(
//                                             name: 'youtube player'),
//                                         builder: (context) => LiveTvPlayer(
//                                               allchannel: allChannels,
//                                               channel: sortedChannel[index],
//                                             )),
//                                   ).whenComplete(() {
//                                     SystemChrome.setPreferredOrientations(
//                                         [DeviceOrientation.portraitUp]);
//                                   });
//                                   _sendChannelInfo(sortedChannel[index]);
//                                 }
//                               }
//                             },
//                             child: Column(
//                                 // mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.symmetric(
//                                           vertical: 10.0, horizontal: 3.0),
//                                       height: height * 0.18,
//                                       width: width * 0.5,
//                                       child: (index == 5)
//                                           ? sortedChannel[index].channelurl !=
//                                                   null
//                                               ? ImageBlur.network(
//                                                   sortedChannel[index]
//                                                       .channelimage,
//                                                   scale: 1.0,
//                                                   fit: BoxFit.cover,
//                                                   //scale: 2.5,
//                                                   //height: 200,
//                                                   blur: 4,
//                                                   overlay: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
// >>>>>>> parent of 1e76bb7 (view all grid+ad middle)
//                                                       Icon(
//                                                             Icons.list,
//                                                             size: 50,
//                                                             color: Colors.white,
//                                                       ),
//                                                       Text(
//                                                             "See More",
//                                                             textAlign: TextAlign.center,
//                                                             style: TextStyle(
//                                                                   fontSize: 30,
//                                                                   color: Colors.white,
//                                                             ),
//                                                       ),
//                                                 ],
//                                           ),
//                                     )
//                                         : ImageBlur.asset(
//                                           "assets/icon/icon.png",
//                                           //scale: 1.0,
//                                           width: width * 0.5,
//                                           fit: BoxFit.cover,
//                                           blur: 4,
//                                           overlay: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                                 children: [
//                                                       Icon(
//                                                             Icons.list,
//                                                             size: width * 0.1,
//                                                             color: Colors.white,
//                                                       ),
//                                                       Text(
//                                                             "See More",
//                                                             textAlign: TextAlign.center,
//                                                             style: TextStyle(
//                                                                   fontSize: width * 0.05,
//                                                                   color: Colors.white,
//                                                             ),
//                                                       ),
//                                                 ],
//                                           ),
//                                     )
//                                         : sortedChannel[index].channelurl != null
//                                         ? FadeInImage.assetNetwork(
//                                           placeholder:
//                                           'assets/image/placeHolder.png',
//                                           image:
//                                           sortedChannel[index].channelimage,
//                                           fit: BoxFit.cover,
//                                           fadeInDuration:
//                                           Duration(seconds: 5),
//                                           fadeInCurve: Curves.bounceIn,
//                                     )
//                                         : ImageBlur.asset(
//                                           "assets/icon/icon.png",
//                                           //scale: 1.0,
//                                           width: width * 0.5,
//                                           fit: BoxFit.cover,
//                                           blur: 4,
//                                           overlay: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                                 children: [
//                                                       Icon(
//                                                             Icons.error_outline_sharp,
//                                                             size: width * 0.1,
//                                                             color: Colors.white,
//                                                       ),
//                                                       Text(
//                                                             "Not Live",
//                                                             textAlign: TextAlign.center,
//                                                             style: TextStyle(
//                                                                   fontSize: width * 0.05,
//                                                                   color: Colors.white,
//                                                             ),
//                                                       ),
//                                                 ],
//                                           ),
//                                     )
//                                 ),
//                                 (index == 5)
//                                     ? Blur(
//                                       blur: 2,
//                                       child: Container(
//                                             color: Colors.black12,
//                                             //width: 200,
//                                             //height: 25,
//                                             child: Text(
//                                                   sortedChannel[index].channelname,
//                                                   style: TextStyle(
//                                                       fontWeight: FontWeight.bold,
//                                                       fontSize: height * 0.025),
//                                                   textAlign: TextAlign.center,
//                                             ),
//                                       ),
//                                 )
//                                     : Container(
//                                       //color: Colors.black12,
//                                       //width: 200,
//                                       // height: 25,
//                                       child: Text(
//                                             sortedChannel[index].channelname,
//                                             style: TextStyle(
//                                                   //fontWeight: FontWeight.bold,
//                                                 fontSize: height * 0.025),
//                                             textAlign: TextAlign.center,
//                                       ),
//                                 ),
//                           ]),
//                 ),
//               ],
//             )
//                 : SizedBox();
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return (index%3==1)?
//               Container(
//                 alignment: Alignment.center,
//                 child: AdWidget(ad: ads['myBanner$index']),
//                 // margin: EdgeInsets.symmetric(
//                 //     vertical: 00.0, horizontal: 3.0),
//                 padding: EdgeInsets.only(bottom: 50),
//                 height: 100,
//                 width: 200,
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   // color: Colors.red,
//                 ),
//               ) :
//               Divider();
//           },
//       ),
//     );
//   }
// }

