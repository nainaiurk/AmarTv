// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_tv/helper/database_helper.dart';
import 'package:live_tv/main.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:live_tv/about_us.dart';
import 'package:live_tv/privacy_policy.dart';
import 'package:live_tv/storage_manager.dart';
import 'package:live_tv/theme_manager.dart';
import 'model/model_user.dart';


Color c = const Color(0xffee9aad);

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String version = "";
  bool loggedIn=false;

  static bool status7=true;

  // static bool kidsMode=false;

  getVersion(){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {

      setState(() {
        version = packageInfo.version;
      });

    });
  }
  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  userLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool temp = (prefs.getBool('logged') ?? false);
    await prefs.setBool('logged', temp);
    setState(() {
      loggedIn=temp;
    });
  }
  setLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged', false);
    setState(() {
      loggedIn=false;
    });
  }
  deleteUser(){
    List<User> temp;
    DatabaseHelper.instance.retrieveUser().then((value) {
     temp=value;
   }).then((value) {
     if(temp.isNotEmpty){
       DatabaseHelper.instance.deleteUser(temp[0].email);
     }
    });

  }
  // Color _textColor = Colors.black;
  // Color _appBarColor = Color.fromRGBO(36, 41, 46, 1);
  // Color _scaffoldBgcolor = Colors.white;
  // getVersion() async {
  //   PackageInfo packageInfo = await  PackageInfo.fromPlatform();
  //   version=packageInfo.version;
  // }
  @override
  void initState() {
    userLoginStatus();
    getVersion();
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'dark';
      if (themeMode == 'light') {
        setState(() {
          status7=false;
        });
      } else {
        //print('setting dark theme');
        setState(() {
          status7=true;
        });
      }
    });
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_)=>ThemeNotifier(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                //color: Colors.black,
                onPressed: () {
                  //Navigator.pop(context); //returns black screen
                  //Navigator.of(context).pop();
                 Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
              //backgroundColor: Colors.white,
              title: const Text(
                "Settings",
                //style: TextStyle(color: Colors.black),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 20.0,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.0,
                          width: 50.0,
                          margin: const EdgeInsets.only(right: 15, left: 15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c,
                          ),
                          child: const Icon(
                            Icons.brightness_4,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Dark Mode",
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                        ),
                      ],
                    ),

                    const Expanded(
                      child: SizedBox(
                          //width: 150.0,
                          //width: MediaQuery.of(context).size.width*0.4,
                        ),
                    ),

                    Switch(
                        //dragStartBehavior: DragStartBehavior.down,
                      value: status7,
                      onChanged: (value) {
                        setState(() {
                          status7=value;
                          if (value == false) {
                            themeChanger.setLightMode();
                          } else {
                            themeChanger.setDarkMode();
                          }
                        });

                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(builder: (BuildContext context) => MyApp()),
                        //     ModalRoute.withName('/')
                        // );
                        // final result =  FlutterRestart.restartApp();
                        //
                        // print(result);

                      },
                    ),

                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          //settings: RouteSettings(name: 'privacy policy'),
                            builder: (context) => PrivacyPolicy()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff9aacee),
                        ),
                        child: Icon(
                          Icons.list_alt,
                          color: Colors.blue,
                        ),
                      ),
                       Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffc4ee9a),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Version",
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "- $version",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          //settings: RouteSettings(name: 'privacy policy'),
                            builder: (context) => AboutUs()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffcecaad),
                        ),
                        child: const Icon(
                          Icons.insert_drive_file_outlined,
                          color: Colors.yellow,
                        ),
                      ),
                     Text(
                          "About",
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                        ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (){
                    _launchURL("bms.global.bd@gmail.com", "Amr TV Bangla- Contact Us", "");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffce91cb),
                        ),
                        child: const Icon(
                          Icons.mail_outline_sharp,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                          "Contact Us",
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (){
                    _share(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffa0c2d7),
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "Share",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                (loggedIn==true)?InkWell(
                  onTap: (){
                    GoogleSignIn().signOut();
                    setLoggedOut();
                    deleteUser();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MyApp()),
                        ModalRoute.withName('/')
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffafa1d5),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const Text(
                        "Sign out",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ):Container(),
              ],
            ),
          );
        }
      ),
    );
  }

  Future<void> _share(BuildContext b) async {
    await Share.share("https://play.google.com/store/apps/details?id=com.bmsglobalbd.AmarTV");
  }
}
