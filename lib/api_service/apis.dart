import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:live_tv/model/model_version.dart';

class Apis {
  final String versionURL =
      "https://amrtvbangla.bmssystems.org/appversionapi.php";


  Future<ModelVersion> fetchVersion(http.Client client) async {
    final response = await http.get(
      Uri.parse(versionURL),
    );
    if (response.statusCode == 200) {
      //final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      //print(jsonDecode(response.body)[0]);

      return ModelVersion.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to load album');
    }
  }
}