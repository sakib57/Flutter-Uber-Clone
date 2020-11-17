import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodedData = jsonDecode(jSonData);
        return decodedData;
      } else {
        return "failed";
      }
    } catch (exp) {
      return "failed";
    }
  }
}
