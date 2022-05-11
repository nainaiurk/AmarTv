import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/gridview.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';

class Category extends StatelessWidget {
  final List<List<ModelChannel>> m;

  const Category({Key key, this.m}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(channel: m),
      theme: themeNotifier.getTheme(),
    );
  }
}

class MyHome extends StatefulWidget {
  final List<List<ModelChannel>> channel;

  const MyHome({Key key, this.channel}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState(channel);
}

class _MyHomeState extends State<MyHome> {
  final List<List<ModelChannel>> channel;

  _MyHomeState(this.channel);

  // List<List<ModelChannel>> categorize(List<ModelChannel> c) {
  //   c.forEach((element) {
  //     if (channelType.isEmpty) {
  //       channelType.add(element.channeltype);
  //     } else {
  //       if (channelType.contains(element.channeltype)) {
  //       } else {
  //         channelType.add(element.channeltype);
  //       }
  //     }
  //   });
  //   List<List<ModelChannel>> countryListTemp = [];
  //   channelType.forEach((countryCode) {
  //     List<ModelChannel> t = [];
  //     c.forEach((element) {
  //       if (element.channeltype == countryCode) {
  //         t.add(element);
  //       }
  //     });
  //     countryListTemp.add(t);
  //   });
  //   return countryListTemp;
  // }

  @override
  void initState() {
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    print(channel.length);
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
          "Categories",
          style: TextStyle(
              //color: Colors.black
              ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          ListView.builder(
            addAutomaticKeepAlives: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: channel.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(children: [
                InkWell(
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'Grid View'),
                            builder: (context) => GridPage(
                              channel: channel[index],
                            ))).whenComplete(() {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    });
                  },
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.04,
                    width: MediaQuery.of(context).size.width*0.80,
                    decoration: BoxDecoration(
                     // color: Color(0xff3accce),
                      color: Color(0xFFDBD8CC),
                      //shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    //color: Colors.blue,
                    child: Center(
                      child: Text(
                        channel[index].elementAt(0).categoryname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,)
              ]);
            },
          )
        ],
      ),
    );
  }
}
