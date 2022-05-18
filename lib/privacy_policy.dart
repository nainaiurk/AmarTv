import 'package:flutter/material.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
      theme: themeNotifier.getTheme(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String s =
      """AmrTv Live (means “mine” or “my”) is committed to protecting the privacy of personal information (i.e.
any information relating to an identified or identifiable natural person) who uses the app. The mobile
software application uses the data from YouTube Links is a public based platform use to get updated
channels. It has public permission to be used on the app. Amendments to this Privacy Policy will be
posted to the application and will be effective when posted. Your continued use of the Services
following the posting of any amendment to this Privacy Policy shall constitute your acceptance of such
amendment.

Your Consent
When you register as a user of our Application, we ask for personal information that will be used to
activate your account, provide the Services to you, communicate with you to notify the updates and for
other purposes set out in this Privacy Policy. You will also be asked to create a username and private
password, which will become part of your account information.

By providing personal information to us and by retaining us to provide you with the Services, you
voluntarily consent to the collection, use and disclosure of such personal information as specified in this
Privacy Policy. The legal bases for our processing of personal information are primarily that the
processing is necessary for providing the Services and that the processing is carried out in our legitimate
interests, which are further explained below. The personal information is going to be secured and not
shared with any third-party.
 """;

  @override
  void initState() {
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            //color: Colors.black,
            onPressed: () {
              //Navigator.pop(context); //returns black screen
              Navigator.of(context, rootNavigator: true).pop(context);
            },
          ),
          //backgroundColor: Colors.white,
          title: Text(
            "Privacy Policy",
            //style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Image.asset(
                      "assets/icon/logo.png",
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.height * 0.10,
                    ),
                  ),
                  Text(
                    "Amr TV Live",
                    style: TextStyle(
                      // decorationStyle: TextDecorationStyle.dotted,
                      wordSpacing: 5.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 2,
                child: Container(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Privacy Policy For Amr TV",
                //textWidthBasis: TextWidthBasis.parent,
                //textScaleFactor: 1.8,
                //textAlign: TextAlign.left,
                style: TextStyle(
                  // decorationStyle: TextDecorationStyle.dotted,
                  //wordSpacing: 10.0,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0,right: 10.0),
                  child: Text(s)),
            ],
          ),
        ));
  }
}
