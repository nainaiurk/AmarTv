import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:live_tv/rewards.dart';
import 'package:live_tv/youtubePlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class Search extends StatelessWidget {
  final List<ModelChannel> filteredChannel;
  final List<ModelChannel> allChannel;
  final String string;

  const Search({Key key, this.filteredChannel, this.allChannel, this.string})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          title: Text(
            "Search",
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
            width: double.infinity,
          ),
          SearchChannels(
              string: string, channel: filteredChannel, channel2: allChannel),
          const SizedBox(
            height: 10,
          ),
          (filteredChannel.isNotEmpty)
              ? Expanded(
                  child: GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: false,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(filteredChannel.length, (index) {
                        return InkWell(
                          onTap: () async {
                            int i = await load();
                            if (i >= 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings:
                                          const RouteSettings(name: 'youtube player'),
                                      builder: (context) => LiveTvPlayer(
                                            channel: filteredChannel[index],
                                          ))).whenComplete(() {
                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.blueGrey[800],
                                    elevation: 24.0,
                                    title: Text(
                                      "You don't have enough coins to watch TV",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0,
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              //width: width*0.25,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              child: TextButton(
                                                child: Text(
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
                                                  Navigator.of(context).pop();
                                                  // Navigator.of(c,rootNavigator: true).pop();
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
                                                  border: Border.all(
                                                      color: Colors.white)),
                                              //width: width*0.25,
                                              child: TextButton(
                                                child: Text(
                                                  "Get Free Coin",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          settings:
                                                              RouteSettings(
                                                                  name:
                                                                      "Reward"),
                                                          builder: (_) =>
                                                              Rewards()));
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Column(children: [
                            filteredChannel[index].channelurl != null
                                ? Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      //  borderRadius: BorderRadius.all(Radius.circular(12)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          filteredChannel[index].channelimage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    child: Image.asset(
                                      "assets/icon/icon.png",
                                      //scale: 1.0,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      fit: BoxFit.cover,).blurred(
                                      blur: 4,
                                      overlay: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline_sharp,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Not Live",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            Container(
                              //color: Colors.black12,
                              //width: 200,
                              //height: 16,
                              child: Text(
                                filteredChannel[index].channelname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  //color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                        );
                      })),
                )
              : Text("Not Found")
        ],
      ),
    );
  }

  Future<int> load() async {
    final SharedPreferences prefs = await _prefs;
    int i = (prefs.getInt("Rcounter") ?? 10);
    return i;
  }
}

class SearchChannels extends StatefulWidget {
  final List<ModelChannel> channel;
  final List<ModelChannel> channel2;
  final String string;

  const SearchChannels({Key key, this.channel, this.channel2, this.string})
      : super(key: key);

  @override
  _SearchChannelsState createState() => _SearchChannelsState(channel, channel2);
}

class _SearchChannelsState extends State<SearchChannels> {
  final List<ModelChannel> channel;
  final List<ModelChannel> channel2;
  List<ModelChannel> filteredChannel = [];
  final myController = TextEditingController();
  bool string = true;

  _SearchChannelsState(this.channel, this.channel2);

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //search bar
      width: 320,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Theme.of(context).hintColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: Theme(
                data: ThemeData(
                  colorScheme: ThemeData().colorScheme.copyWith(
                        primary: Colors.grey[700],
                      ),
                ),
                child: TextField(
                  controller: myController,
                  autofocus: true,
                  cursorColor: Colors.red,
                  onSubmitted: (string) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Search(
                                  filteredChannel: channel,
                                  string: string,
                                  allChannel: channel2,
                                ))).whenComplete(() {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    });
                  },
                  onChanged: (string) {
                    setState(() {
                      filteredChannel = channel2
                          .where((element) => (element.channelname
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                          .toList();
                    });
                  },

                  onTap: () {},
                  //readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    //errorText: string? null: "Input Channel Name",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    hintText: 'Search Channel Name',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      //splashColor: Colors.blue,
                      splashRadius: 5.0,
                      //color: Colors.blue,
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search(
                                        filteredChannel: filteredChannel,
                                        string: myController.text,
                                        allChannel: channel2,
                                      ))).whenComplete(() {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          });
                        } else {
                          setState(() {
                            string = false;
                          });
                        }
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
    );
  }
}
