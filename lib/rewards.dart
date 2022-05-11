import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Rewards extends StatefulWidget {
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  RewardedAd rewardedAd;
  int reward;
  bool load = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _loadCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      reward = (prefs.getInt('Rcounter') ?? 10);
    });
  }

  _incrementCounter() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      reward = (preferences.getInt('Rcounter') ?? 10) + 10;
      preferences.setInt('Rcounter', reward);
    });
  }

  _incrementCounterBig() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      reward = reward + 10;
      preferences.setInt('Rcounter', reward);
    });
  }

  void watchVideo() {
    if (load == true) {
      rewardedAd.show();
    } 
    else {
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
  Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  Future<bool> loadRewardStorePref() async {
    final SharedPreferences prefs = await _prf;
    bool i = (prefs.getBool("rewardStore") ?? false);
    setState(() {
      rewardStoreRecieved = i;
    });
    return i;
  }

  Future<bool> loadRewardFBPref() async {
    final SharedPreferences prefs = await _prf;
    bool i = (prefs.getBool("rewardFB") ?? false);
    setState(() {
      rewardFBRecieved = i;
    });
    return i;
  }

  void zeroRewardStorePref() async {
    SharedPreferences preference = await _prefs;
      preference.setBool('rewardStore', true);
  }

  void zeroRewardFBPref() async {
    SharedPreferences preference = await _prefs;
    preference.setBool('rewardFB', true);
  }

  var pageLink = "https://www.facebook.com/Amr-TV-100453655696187/";
  void _launchFBURL() async => await canLaunch(pageLink)
    ? await launch(pageLink)
    : throw 'Could not launch $pageLink';

  var storeLink = "https://play.google.com/store/apps/details?id=com.bmsglobalbd.AmarTV";

  void _launchStoreURL() async => await canLaunch(storeLink)
      ? await launch(storeLink)
      : throw 'Could not launch $storeLink';

  bool rewardStoreRecieved = false;
  bool rewardFBRecieved = false;

  @override
  void initState() {
    // TODO: implement initState
    rewardedAd = RewardedAd(
      adUnitId: 'ca-app-pub-6179877812536274/9967551135',
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            load = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
          _incrementCounter();
          rewardedAd.dispose();
          setState(() {
            load=false;
          });
          rewardedAd.load();
          print(reward.type);
          print(reward.amount);
        },
      ),
    );
    rewardedAd.load();
    loadRewardStorePref();
    loadRewardFBPref();
    _loadCounter();
    super.initState();
  }

  @override
  void dispose() {
    rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rewards',
        ),
        actions: const <Widget>[],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Unlock All TV',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Image(
            image: const AssetImage("assets/image/gold.png"),
            height: MediaQuery.of(context).size.width * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          Text(
            "$reward",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.2,
              color: Colors.yellow[700],
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: ElevatedButton(
              onPressed: watchVideo,
              child: const Text(
                'Unlock TV',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow[800]),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Watch the full Video to unlock all channels',
            style: TextStyle(color: Colors.yellow[700]),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: ()async{
                  rewardStoreRecieved = await loadRewardStorePref();
                  // print('$rewardStoreRecieved');

                  if(!rewardStoreRecieved){
                    _launchStoreURL();
                    _incrementCounterBig();
                    setState(() {
                      rewardStoreRecieved = true;
                    });
                    zeroRewardStorePref();
                  }
                  // print('$rewardStoreRecieved');

                },
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width*.4,
                  decoration: BoxDecoration(
                    color: rewardStoreRecieved?Colors.grey.shade900:Colors.grey.shade700,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Give Feedback',style: TextStyle(color: Colors.white.withOpacity(.8),fontSize: 15),),
                      Text('50',style: TextStyle(color: Colors.yellow[800],fontSize: 50),),
                      Text('coins',style: TextStyle(color: Colors.white.withOpacity(.8),fontSize: 15),),
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: ()async{
                  rewardFBRecieved = await loadRewardFBPref();
                  // print('$rewardFBRecieved');

                  if(!rewardFBRecieved){
                    _launchFBURL();
                    _incrementCounterBig();
                    setState(() {
                      rewardFBRecieved = true;
                    });
                    zeroRewardFBPref();
                  }
                  print('$rewardFBRecieved');
                },
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width*.4,
                  decoration: BoxDecoration(
                    color: rewardFBRecieved?Colors.grey.shade900:Colors.grey.shade700,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Like FB page',style: TextStyle(color: Colors.white.withOpacity(.8),fontSize: 15),),
                      Text('50',style: TextStyle(color: Colors.yellow[800],fontSize: 50),),
                      Text('coins',style: TextStyle(color: Colors.white.withOpacity(.8),fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
