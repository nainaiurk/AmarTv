import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridViewWidget extends StatelessWidget {
  GridViewWidget({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final List channel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: channel.length,
      padding: const EdgeInsets.fromLTRB(25,0,25,0),
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 25,
        mainAxisExtent: 130,
        crossAxisCount: 3,
      ),
      itemBuilder: (context,index){
        return InkWell(
          onTap: () async {
            int i = await load();
            if (channel[index].channelurl == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.purpleAccent[800],
                behavior: SnackBarBehavior.floating,
                //width: MediaQuery.of(context).size.width*0.5,
                elevation: 20.0,
                content: const Text(
                  "The channel is not live now, try again later",
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 5),
              ));
            } 
            else {
              if (i >= 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: 'youtube player'),
                        builder: (context) => LiveTvPlayer(
                          channel: channel[index],
                        ))).whenComplete(() {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                });
              } 
            }
          },
          child: channel[index].channelurl != null
          ? CachedNetworkImage(      
            fit: BoxFit.fitHeight,
            imageUrl: channel[index].channelimage,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage: imageProvider,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),          
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,10,10,12),
                    child: Text(
                      channel[index].channelname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        overflow: TextOverflow.visible,
                        color: Colors.white,
                        backgroundColor: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  )
                ),
              ),
            ),
            placeholder: (context, url) => const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/image/placeHolder.png')
            )
          )
          : CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45,
            child: Image.asset(
              "assets/icon/icon.png",
              fit: BoxFit.fitHeight,).blurred(
              borderRadius:BorderRadius.circular(60),
              blur: 4,
              overlay: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(
                    Icons.error_outline_sharp,
                    size: 40,
                    color: Colors.white,
                  ),
                  Text(
                    channel[index].channelname,
                    textAlign:TextAlign.center,
                    style: const TextStyle(
                      fontSize:12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        );
      }
    );
  }
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
   Future<int> load() async {
    final SharedPreferences prefs = await _prefs;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }
}
