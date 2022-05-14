// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/gridview.dart';
import 'package:live_tv/model/modelChannel.dart';

class CountryName extends StatelessWidget {
  final List<ModelChannel> channel;

  const CountryName(this.channel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      // first listview
      children: <Widget>[
        (channel.isEmpty)
          ? const SizedBox(height: 0.1,)
          : Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  channel.isEmpty ? "Loading" : channel[0].categoryname,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red
                  ),
                  //textScaleFactor: 1.5,
                ),
              ),
            ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: 'Grid View'),
                    builder: (context) => GridPage(
                          channel: channel,
                        ))).whenComplete(() {
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            });
          },
          child: channel.length > 5
              ? Container(
                  margin: EdgeInsets.only(right: width*0.01),
                    height: height * 0.03,
                    width: width * 0.18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                    //padding: EdgeInsets.all(10),
                    child: Text(
                      "See All",
                      softWrap: true,
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        //backgroundColor: Colors.red,
                        fontWeight: FontWeight.bold, fontSize: width * 0.03,
                        color: Colors.white,
                        // background:,
                      ),
                    ),
                  )
              : const SizedBox(
                  // height: 1,
                  // width: 1,
                  ),
        ),
      ],
    );
  }
}
