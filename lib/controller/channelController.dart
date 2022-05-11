import 'dart:convert';

import 'package:get/get.dart';
import 'package:live_tv/model/feature_model.dart';
import 'package:live_tv/model/modelChannel.dart';
import 'package:http/http.dart' as http;

class ChannelController extends GetxController {
  List<List<ModelChannel>> allChannelList = [];

  RxList<ModelChannel> allTVChannelCat1 = <ModelChannel>[].obs;
  RxList<ModelChannel> allTVChannelCat2 = <ModelChannel>[].obs;
  RxList<ModelChannel> allTVChannelCategory = <ModelChannel>[].obs;



  List<String> channelType = [];

  List<ModelChannel> allChannelsResponse = [];

  RxList<ModelChannel> allChannelGet = <ModelChannel>[].obs;

  // var products = await RemoteServices.fetchProducts();
  // if(products!=null){
  //   productList.value=products;
  // }

  List<ModelChannel> parseChannel(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ModelChannel>((json) => ModelChannel.fromJson(json))
        .toList();
  }

  Future<List<ModelChannel>> getData() async {
    final response = await http
        .get('https://amrtvbangla.bmssystems.org/fetch_jason_all_channels.php');
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('getx res');

      allChannelsResponse = parseChannel(response.body);

      print('getx parse');

      allChannelsResponse.forEach((element) {
        if (channelType.isEmpty) {
          channelType.add(element.channeltype);
        } else {
          if (channelType.contains(element.channeltype)) {
          } else {
            channelType.add(element.channeltype);
          }
        }
      });

      print('getx bef');

      channelType.forEach((countryCode) {
        List<ModelChannel> t = [];
        allChannelsResponse.forEach((element) {
          if (element.channeltype == countryCode) {
            allChannelGet.value.add(element);
            t.add(element);
          }
        });

        allChannelList.add(t);
      });

      // allChannelGet.value = allChannelList;

      print('getx');
      print(allChannelGet.length);

      return parseChannel(response.body);
      // print('total country ${countryList.length}');
      // print(countryList[0].elementAt(0).categoryname);
      // print(countryList[0].length);

    } else {
      //If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  
  
  void getChannels(ModelChannel channel) {
    allTVChannelCategory.clear();
    allTVChannelCat1.clear();
    allTVChannelCat2.clear();

    allChannelGet.forEach((element) {
      if (element.categoryname == channel.categoryname &&
          element.channelname != channel.channelname) {
        allTVChannelCat1.add(element);
      } else if (element.categoryname != channel.categoryname) {
        allTVChannelCat2.add(element);
      }
    });
    allTVChannelCategory =
        allTVChannelCat1 + allTVChannelCat2;
  }



  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
