// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, unused_catch_clause, sized_box_for_whitespace
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:live_tv/api_service/apis.dart';
import 'package:live_tv/category.dart';
import 'package:live_tv/controller/channelController.dart';
import 'package:live_tv/favorite.dart';
import 'package:live_tv/gridview.dart';
import 'package:live_tv/helper/database_helper.dart';
import 'package:live_tv/horizontalScrollView.dart';
import 'package:live_tv/model/feature_model.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/model/modelFavorite.dart';
import 'package:live_tv/model/model_user.dart';
import 'package:live_tv/model/model_version.dart';
import 'package:live_tv/searchChannel.dart';
import 'package:live_tv/settings.dart';
import 'package:live_tv/sign_in.dart';
import 'package:live_tv/sign_up.dart';
import 'package:live_tv/textDesign.dart';
import 'package:live_tv/top_ten_grid.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // setUpLocator();
  // debugPaintSizeEnabled=true;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds:["A78ACFFEC502EA889D3C72628759CC36"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider<ThemeNotifier>(

    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amr TV',
      theme: themeNotifier.getTheme(),
      // navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      home: const MyHomePage(
          title: 'Amr TV',
          // analytics: locator<AnalyticsService>().getAnalytics(),
          // observer: locator<AnalyticsService>().getAnalyticsObserver()),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}): super(key: key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prf = SharedPreferences.getInstance();

  final ChannelController channelController = Get.put(ChannelController());

  String _connectionStatus = 'Unknown';
  int counter;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  _MyHomePageState();

  TextEditingController _controller;

  int _current = 0; //for image carousel counter
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isSearching = false;
  List<List<ModelChannel>> countryList = [];
  String appVersion = "";
  String s1, s2, sub;
  List<List<ModelFeature>> featureList = [];
  List<Favorite> fav = [];
  List<String> channelType = [];
  List<String> featureChannelType = [];
  List<ModelChannel> filteredChannel = [];
  List<ModelChannel> listTemp = [];
  List<ModelFeature> allFeatures;
  List<ModelChannel> allChannels = [];
  List<User> user;
  ModelVersion modelVersion;
  String version = "";
  int _counter=0;
  bool splash = false;
  bool loggedIn;

  // Future<void> _sendChannelInfo(
  //     FirebaseAnalytics a, ModelChannel modelChannel) async {
  //   await a.logEvent(name: "Tapped_Channel", parameters: <String, String>{
  //     "Channel_Name": modelChannel.channelname,
  //
  //   });
  // }
  Future<bool> userLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool temp = (prefs.getBool('logged') ?? false);
    await prefs.setBool('logged', temp);
    setState(() {
      loggedIn = temp;
    });
    return temp;
  }

  getUser() {
    DatabaseHelper.instance.retrieveUser().then((value) {
      if (value != null) {
        // print(value);
        setState(() {
          user = value;
        });
      }
    });
  }

  /// like app? continue as guest/ sign in
  _showDialog(BuildContext c) async {
    showDialog(
        context: c,
        //useRootNavigator: true,
        barrierDismissible: true,
        builder: (c) {
          return AlertDialog(
            elevation: 24.0,
            backgroundColor: Colors.grey,
            title: const Text(
              'Liking our app?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextButton(
                        child: const Text(
                          "Continue as Guest",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          _setToZero();
                          //Navigator.of(context, rootNavigator: true).pop();
                          // Navigator.pop(buildContext);
                          // Navigator.pop(buildContext);
                          Navigator.of(c, rootNavigator: true).pop();
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
                          border: Border.all(color: Colors.white)),
                      child: TextButton(
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          _setToZero();
                          Navigator.of(c, rootNavigator: true).pop();
                          Navigator.push(
                              c,
                              MaterialPageRoute(
                                  settings: const RouteSettings(name: "Sign up"),
                                  builder: (_) => SignUp()));

                          // Navigator.pop(c);
                          //Navigator.of(c, rootNavigator: true).pop();
                          //Navigator.pop(c);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  ///new version released. update
  _showPopUpDialog(BuildContext c) async {
    //await Future.delayed(Duration(seconds: 1));
    showDialog(
      context: c,
      //useRootNavigator: true,
      barrierDismissible: false,
      builder: (c) {
        return AlertDialog(
          elevation: 24.0,
          backgroundColor: Colors.grey,
          title: const Text(
            'New Version Released',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'Please update your app to Continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white)),
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
                        SystemNavigator.pop();
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
                        border: Border.all(color: Colors.white)),
                    child: TextButton(
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _launchURL(
                            "https://play.google.com/store/apps/details?id=com.bmsglobalbd.AmarTV");
                        // Navigator.of(c, rootNavigator: true).pop();
                        // Navigator.push(
                        //     c,
                        //     MaterialPageRoute(
                        //         settings: RouteSettings(name: "Sign up"),
                        //         builder: (_) => SignUp()));

                        // Navigator.pop(c);
                        //Navigator.of(c, rootNavigator: true).pop();
                        //Navigator.pop(c);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }

  _incrementCounter() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      _counter = (preferences.getInt('counter') ?? 0) + 1;
      preferences.setInt('counter', _counter);
    });
    // print("in counter"+_counter.toString());
  }

  List<ModelChannel> sortChannel(List<ModelChannel> channel) {
    channel.sort((a, b) => a.channelurl == null
        ? 1
        : b.channelurl == null
            ? -1
            : a.channelurl.compareTo(b.channelurl));
    return channel;
  }

  _setToZero() async {
    SharedPreferences preferences = await _prefs;
    setState(() {
      _counter = 1;
      preferences.setInt('counter', _counter);
    });
  }

 Future<int> _loadCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _counter = (prefs.getInt("counter") ?? 0);
    });
    // print("load counter"+_counter.toString());
    return _counter;
  }

  List<ModelChannel> convert(AsyncSnapshot<List<Favorite>> s) {
    List<ModelChannel> temp = [];
    s.data.forEach((element) {
      ModelChannel modelTemp = ModelChannel(
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

  List<ModelChannel> converts(List<Favorite> s) {
    List<ModelChannel> temp = [];
    s.forEach((element) {
      ModelChannel modelTemp = ModelChannel(
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

  List<ModelChannel> convertFeatured(List<ModelFeature> f) {
    List<ModelChannel> temp = [];
    f.forEach((element) {
      ModelChannel modelTemp = ModelChannel(
          the0: element.channelid,
          the1: element.featurename,
          the2: element.channelid,
          the3: element.channelname,
          the4: element.channelimage,
          the6: element.channelurl,
          channelid: element.channelid,
          categoryname: element.featurename,
          channeltype: element.channelid,
          channelname: element.channelname,
          channelimage: element.channelimage,
          channelurl: element.channelurl);
      temp.add(modelTemp);
    });
    return temp;
  }

  List<ModelChannel> parseChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ModelChannel>((json) => ModelChannel.fromJson(json))
        .toList();
  }

  List<ModelFeature> parseFeaturedChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ModelFeature>((json) => ModelFeature.fromJson(json))
        .toList();
  }

  Future<List<ModelFeature>> getFeaturedData(http.Client client) async {
    final r = await http
        .get(Uri.parse('https://amrtvbangla.bmssystems.org/featuredchannelsapi.php'));
    if (r.statusCode == 200) {
      setState(() {
        allFeatures = parseFeaturedChannel(r.body);
      });
      //print("Feature channel ${allFeatures.length}");
      allFeatures.forEach((element) {
        if (featureChannelType.isEmpty) {
          featureChannelType.add(element.featurename);
        } else {
          if (featureChannelType.contains(element.featurename)) {
          } else {
            featureChannelType.add(element.featurename);
          }
        }
      });
      featureChannelType.forEach((countryCode) {
        List<ModelFeature> t = [];
        allFeatures.forEach((element) {
          if (element.featurename == countryCode) {
            t.add(element);
          }
        });
        setState(() {
          featureList.add(t);
        });
      });
      //print(featureList[0]);
      // print('total country ${featureList.length}');
      // print(featureList[0].elementAt(0).featurename);
      // print(featureList[0].length);
      return parseFeaturedChannel(r.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ModelChannel>> getData(http.Client client) async {
  //  print('getx getdata');
  //  print('${channelController.allChannelGet.value.length}');

    final response = await http
        .get(Uri.parse('https://amrtvbangla.bmssystems.org/fetch_jason_all_channels.php'));
    // print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        allChannels = parseChannel(response.body);
      });

      allChannels.forEach((element) {
        if (channelType.isEmpty) {
          channelType.add(element.channeltype);
        } else {
          if (channelType.contains(element.channeltype)) {
          } else {
            channelType.add(element.channeltype);
          }
        }
      });

      channelType.forEach((countryCode) {
        List<ModelChannel> t = [];
        allChannels.forEach((element) {
          if (element.channeltype == countryCode) {
            t.add(element);
          }
        });
        countryList.add(t);
      });
      // print('total country ${countryList.length}');
      // print(countryList[0].elementAt(0).categoryname);
      // print(countryList[0].length);
      return parseChannel(response.body);
    } else {
      //If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(_connectionStatus),
        //   duration: Duration(seconds: 3),
        // ));
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        if (_connectionStatus.contains("Failed")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_connectionStatus),
            duration: const Duration(seconds: 3),
          ));
        }

        break;
    }
  }

  checkVersion() {

    Apis().fetchVersion(http.Client()).then((value) {
      modelVersion = value;
      s1 = modelVersion.s0;
      version = s1;
      // print("s1 " + s1);

    }).whenComplete(() {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        s2 = packageInfo.version;
        appVersion = s2;
        sub = s2.substring(0, 1);
        // print("s2 " + sub);
      }).whenComplete(() {
        if (s1.compareTo(sub) == 0) {
          // print("equal");
        } else {
          // print("not equal");
          Future.delayed(const Duration(seconds: 5), () {
            _showPopUpDialog(context);
          });
        }
      });

    });
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  getDialog(){
   bool temp;
   userLoginStatus().then((value) {
     temp=value;
    //  print(value);
   });
    _loadCounter().then((value) {

      if ((temp != true) &&
          (value != null && value % 5 == 0) &&
          (version == appVersion)) {
        // print("now");
        // print("get counter"+_counter.toString());
        Future.delayed(const Duration(seconds: 5), () {
          _showDialog(context);
        });
      }
    });
  }


  ModelChannel convertSingle(Favorite data) {
    ModelChannel m = ModelChannel(
        the0: data.channelId,
        the1: data.channelName,
        the2: data.channelType,
        the3: data.channelCategory,
        the4: data.channelImage,
        the6: data.channelUrl,
        channelid: data.channelId,
        categoryname: data.channelCategory,
        channeltype: data.channelType,
        channelname: data.channelName,
        channelimage: data.channelImage,
        channelurl: data.channelUrl);
    return m;
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prf;
    int i = (prefs.getInt("Rcounter") ?? 3);
    return i;
  }

  @override
  void initState() {
    super.initState();
    userLoginStatus();
    //getDialog();
    checkVersion();
    getUser();
    //getAppVersion();
    //checkVersions(version, appVersion);
    //print(version);

    Future.delayed(const Duration(seconds: 3, milliseconds: 400), () {
      setState(() {
        splash = true;
      });
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _loadCounter();
    _incrementCounter();

    //print("counter "+_counter.toString());
    
    getData(http.Client());
    getFeaturedData(http.Client());
    load().then((value) {
      counter = value;
    });
    // DatabaseHelper.instance.retrieveFavorite();

    _controller = TextEditingController();

  }

  @override
  void dispose() {
    _controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return splash
      ? Scaffold(
          drawer: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Drawer(
              //elevation: 2.0,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: DrawerHeader(
                      //curve: Curves.easeInOutBack,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 5.0),
                                  height: MediaQuery.of(context).size.width *
                                      0.25,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:loggedIn==false|| user.isEmpty ||
                                              user == null ||
                                                  user[0].image.isEmpty
                                              ? const AssetImage(
                                                  "assets/icon/icon.png",
                                                )
                                              : NetworkImage(user[0].image))),
                                  width: MediaQuery.of(context).size.width *
                                      0.25,
                                  // child: Image.asset(
                                  //   "assets/icon/logo.png",
                                  //   fit: BoxFit.cover,scale: 2.0,
                                  // ),
                                ),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  loggedIn==false||user.isEmpty || user == null
                                          ? Text(
                                              'Amr TV',
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                              ),
                                            )
                                          : Text(
                                              user[0].name,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Watch Your Favorite Tv Channels',
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child:
                        ListView(
                          children: [
                          ListTile(
                            title: Text(
                              "Home",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            leading: Icon(
                              Icons.home,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text(
                              "All Channels",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.05),
                            ),
                            leading: Icon(
                              Icons.tv,
                              size: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.06,
                            ),
                            onTap:
                                () {
                              // print('getx getobx');
                              // print('${channelController.allChannelGet.value.length}');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GridPage(
                                        channel: channelController.allChannelGet
                                            .value,
                                      ),
                                ),
                              ).whenComplete(() {
                                SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              "Favorites",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            leading: Icon(
                              Icons.favorite_border,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteGrid(),
                                ),
                              ).whenComplete(() {
                                SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]);
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              "Category",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            leading: Icon(
                              Icons.file_copy,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              //Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: 'Category'),
                                  builder: (context) =>
                                      Category(m: countryList)
                                )
                              ).whenComplete(() {
                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.portraitUp]);
                                }
                              );
                            },
                          ),
                          ListTile(
                            title: Text(
                              "Top 10 Channels",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            leading: Icon(
                              Icons.bar_chart,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings:
                                      RouteSettings(name: 'Top 10 page'),
                                      builder: (context) => TopGridPage()))
                                  .whenComplete(() {
                                SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]);
                              });
                            },
                          ),
                          loggedIn == true
                              ? Container()
                              : ListTile(
                            title: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width *
                                      0.05),
                            ),
                            leading: Icon(
                              Icons.perm_identity_outlined,
                              size:
                              MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings:
                                      RouteSettings(name: 'login page'),
                                      builder: (context) =>
                                          SignIn())).whenComplete(() {
                                userLoginStatus();
                                getUser();
                              });
                            },
                          ),
                          // ListTile(
                          //   title: Text(
                          //     "Get Free Coins",
                          //     style: TextStyle(
                          //         fontSize:
                          //         MediaQuery.of(context).size.width * 0.05,
                          //         color: Color(0xFFFFD700)),
                          //   ),
                          //   leading: Icon(
                          //     Icons.monetization_on_outlined,
                          //     size: MediaQuery.of(context).size.width * 0.06,
                          //     color: Color(0xFFFFD700),
                          //   ),
                          //   onTap: () {
                          //     //load();
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             settings: RouteSettings(name: 'login page'),
                          //             builder: (context) => Rewards()));
                          //   },
                          // ),
                          ListTile(
                            title: Text(
                              "Settings",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            leading: Icon(
                              Icons.settings,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         settings: RouteSettings(name: 'Settings'),
                              //         builder: (context) => Settings()));
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                  builder: (_) => const Settings()))
                                  .whenComplete(() {
                                getUser();
                                userLoginStatus();
                              });
                            },
                          ),
                        ]
                      ),

                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: !isSearching
                ? Row(
                    children: [
                      Image.asset(
                        'assets/icon/icon.png',
                        height: 40,
                      ),
                      Text(widget.title,),
                    ],
                  )
                : Container(
                    //search bar
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Theme.of(context).hintColor,
                      //boxShadow: kElevationToShadow[6],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              //color: Theme.of(context).canvasColor,
                            ),
                            padding: const EdgeInsets.only(left: 16),
                            child: Theme(
                              data: ThemeData(
                                colorScheme: ThemeData().colorScheme.copyWith(
                                      primary: Colors.grey[700],
                                    ),
                              ),
                              child: TextField(
                                controller: _controller,
                                enableInteractiveSelection: true,
                                enableSuggestions: true,
                                cursorColor: Colors.red,
                                cursorWidth: 2,
                                cursorHeight: 20,
                                autofocus: false,
                                onSubmitted: (string) {
                                  setState(() {
                                    isSearching = !isSearching;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Search(
                                                filteredChannel:
                                                    filteredChannel,
                                                string: string,
                                                allChannel: allChannels,
                                              ))).whenComplete(() {
                                    SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.portraitUp]);
                                  });
                                },
                                onChanged: (string) {
                                  setState(() {
                                    filteredChannel = allChannels
                                        .where((element) => (element
                                            .channelname
                                            .toLowerCase()
                                            .contains(string.toLowerCase())))
                                        .toList();
                                  });
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  //hintMaxLines: 3,
                                  hintText: 'Search Channel Name',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    //splashColor: Colors.blue,
                                    splashRadius: 5.0,
                                    //color: Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        isSearching = !isSearching;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Search(
                                                    filteredChannel:
                                                        filteredChannel,
                                                    string: _controller.text,
                                                    allChannel: allChannels,
                                                  ))).whenComplete(() {
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.portraitUp]);
                                      });
                                    },
                                  ),
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                  //fillColor: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            actions: <Widget>[
              IconButton(
                icon: !isSearching ? const Icon(Icons.search) : const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
              )
            ],
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            //reverse: true,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                const SizedBox(height: 20,),
                allFeatures != null
                  ? CarouselSlider.builder(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.2,
                        autoPlay: false,
                        //pageSnapping : false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        //aspectRatio: 16/9,
                        viewportFraction: 0.85,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        scrollDirection: Axis.horizontal
                      ),
                      itemCount: featureList.length,
                      itemBuilder:
                          (BuildContext context, int itemIndex, r) {
                        return (featureList.isNotEmpty)
                            ? InkWell(
                                onTap: () {
                                  List<ModelChannel> m = convertFeatured(
                                      featureList[itemIndex]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GridPage(
                                              channel: m,
                                            )),
                                  ).whenComplete(() {
                                    SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.portraitUp]);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          'https://amrtvbangla.bmssystems.org/${featureList[itemIndex].elementAt(0).featureimagepath}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator();
                      },
                    )
                  : Container(),
                Row(
                  //for determining image position
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: featureList.map((url) {
                    int index = featureList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // boxShadow: BoxShadow(color: ),
                        color: _current == index
                            ? const Color.fromRGBO(246, 3, 3, 0.9019607843137255)
                            : const Color.fromRGBO(113, 111, 111, 1.0),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20,),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: countryList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: height*0.2,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountryName(countryList[index]),
                          Scroll(
                            allChannels: allChannels,
                            channel: countryList[index],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 72,),
              ],
            ),
          ),
        )
      : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin:EdgeInsets.only(top: height * 0.45, bottom: height * 0.45),
          child: Image.asset(
            "assets/image/spash1.gif",
            //fit: BoxFit.cover,
          ),
        );
  }

  // modelFavorite to modelChannel


// void checkPoints() {
//   int r =
//       await load();
//
//   if (r >= 100) {
//     ModelChannel t =
//     convertSingle(
//         snapshot.data[
//         index]);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) =>
//             LiveTvPlayer(
//               channel: t,
//             ),
//       ),
//     );
//   } else {
//     showDialog(
//       context:
//       context,
//       builder:
//           (context) {
//         return AlertDialog(
//           backgroundColor:
//           Colors.blueGrey[
//           800],
//           elevation:
//           24.0,
//           title: Text(
//             "You don't have enough coins to watch TV",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 "Watch Later",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               onPressed: () {
//
//                 //Navigator.of(context, rootNavigator: true).pop();
//                 // Navigator.pop(buildContext);
//                 // Navigator.pop(buildContext);
//                 Navigator.of(context).pop();
//                 // Navigator.of(c,rootNavigator: true).pop();
//                 //_incrementCounter();// for fixing bug
//
//                 //Navigator.of(context, rootNavigator: true).pop(context);
//                 //Navigator.of(context).popUntil((route) => false);
//               },
//             ),
//             TextButton(
//               child: Text(
//                 "Watch Now",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         settings: RouteSettings(name: "Reward"),
//                         builder: (_) => Rewards()));
//
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
}
