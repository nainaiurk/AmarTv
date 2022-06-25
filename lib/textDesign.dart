// ignore_for_file: file_names

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:live_tv/gridview.dart';
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
      ],
    );
  }
}
