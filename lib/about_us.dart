import 'dart:io';
import 'package:flutter/material.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHome(),
      theme: themeNotifier.getTheme(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String s =
      """Watch 100% Live TV channels from different countries on Amr TV Live.

  Amr TV Live is an app that gives you binge-worthy moments by fulfilling all your demands in just one app. You can explore exclusive and unique TV channels just by entering the world of Amr TV Live. This app gives you access to several TV shows, news, sports, entertainment and so much more. You can see the live telecast of all your favourite available public channels in our app. Also, all local and international events are live telecast in our app. All you have to do is choose the country from the category you want to watch channels from. This app comes in two designs. One for television use and another for mobile screen use. You can easily connect this app to your TV and watch all your start streaming it on a bigger screen.

  Let’s have a brief look at the best features that you will experience in our app.

  Best audio quality.
  Best video quality.
  Comes in two design – TV screen use, mobile screen use.
  Easy full-screen mode.
  No buffering while watching a video.
  No noise.
  Fastest update.
  Fastest connection.
  Easier to operate.
  Easier to connect.
  """;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  // _launchURL(String toMailId, String subject, String body) async {
  //   var url = 'mailto:$toMailId?subject=$subject&body=$body';
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // final Email email = Email(
  //   body: 'Email body',
  //   subject: 'Email subject',
  //   recipients: ['example@example.com'],
  //   cc: ['cc@example.com'],
  //   bcc: ['bcc@example.com'],
  //   isHTML: false,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          //color: Colors.black,
          onPressed: () {
            //Navigator.pop(context); //returns black screen
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
        title: const Text(
          "About",
          style: TextStyle(
              //color: Colors.black
              ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            //       child: Image.asset(
            //         "assets/icon/logo.png",
            //         fit: BoxFit.cover,
            //         height: MediaQuery.of(context).size.height * 0.15,
            //         width: MediaQuery.of(context).size.height * 0.15,
            //       ),
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Amr TV Live",
            //           //textWidthBasis: TextWidthBasis.parent,
            //           textScaleFactor: 1.5,
            //           style: TextStyle(
            //             // decorationStyle: TextDecorationStyle.dotted,
            //             wordSpacing: 5.0,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18,
            //           ),
            //         ),
            //         Text(
            //           "Watch Your Favorite TV Channels",
            //           softWrap: true,
            //           //textWidthBasis: TextWidthBasis.parent,
            //           //textScaleFactor: 1.2,
            //           style: TextStyle(
            //             // decorationStyle: TextDecorationStyle.dotted,
            //             wordSpacing: 5.0,
            //             //fontWeight: FontWeight.bold,
            //             fontSize: 18,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.height * 0.07,
            //       width: MediaQuery.of(context).size.height * 0.07,
            //       margin: EdgeInsets.only(left: 15, right: 15),
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xffdea2a2),
            //       ),
            //       child: Icon(
            //         Icons.account_balance_outlined,
            //         color: Colors.red,
            //         size: 50,
            //       ),
            //     ),
            //
            //     //await canLaunch('https://hiphopnblog.com/privacy-policy/') ? await launch('https://hiphopnblog.com/privacy-policy/') : throw 'Could not launch';
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //       //settings: RouteSettings(name: 'privacy policy'),
            //     //         builder: (context) => PrivacyPolicy()));
            //
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Company",
            //           //textWidthBasis: TextWidthBasis.parent,
            //           //textScaleFactor: 1.2,
            //           style: TextStyle(
            //             // decorationStyle: TextDecorationStyle.dotted,
            //             wordSpacing: 5.0,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 24,
            //           ),
            //         ),
            //         Text(
            //           "BMS GLOBAL BD",
            //           //textWidthBasis: TextWidthBasis.parent,
            //           //textScaleFactor: 1.2,
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 25,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     InkWell(
            //       onTap: () async {
            //         //_launchURL("bms.global.bd@gmail.com", "Play Time - Contact Us", "");
            //         //await FlutterEmailSender.send(email);
            //       },
            //       child: Container(
            //         height: MediaQuery.of(context).size.height * 0.07,
            //         width: MediaQuery.of(context).size.height * 0.07,
            //         margin: EdgeInsets.only(left: 15, right: 15),
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Color(0xff5ab2db),
            //         ),
            //         child: Icon(
            //           Icons.email_outlined,
            //           color: Colors.blue,
            //           size: 50,
            //         ),
            //       ),
            //     ),
            //
            //     //await canLaunch('https://hiphopnblog.com/privacy-policy/') ? await launch('https://hiphopnblog.com/privacy-policy/') : throw 'Could not launch';
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //       //settings: RouteSettings(name: 'privacy policy'),
            //     //         builder: (context) => PrivacyPolicy()));
            //
            //     InkWell(
            //       onTap: () {
            //         // _launchURL("bms.global.bd@gmail.com", "Play Time - Contact Us", "");
            //       },
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Email",
            //             //textWidthBasis: TextWidthBasis.parent,
            //             //textScaleFactor: 1.2,
            //             style: TextStyle(
            //               // decorationStyle: TextDecorationStyle.dotted,
            //               wordSpacing: 5.0,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 24,
            //             ),
            //           ),
            //           Text(
            //             "bms.global.bd@gmail.com",
            //             //textWidthBasis: TextWidthBasis.parent,
            //             //textScaleFactor: 1.2,
            //             style: TextStyle(
            //               // decorationStyle: TextDecorationStyle.dotted,
            //
            //               //fontWeight: FontWeight.bold,
            //               fontSize: 22,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 5,
            ),
            Container(
                child: Text(s),
            margin: const EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
