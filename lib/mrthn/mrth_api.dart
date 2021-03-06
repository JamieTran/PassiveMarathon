import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;


class MrthnAPI {
  static Future<String> fetchDistance(String mrthnID, String date) async {
    // TODO: make user & date dynamic for what is being requested
    // TODO: also make authentication token private
    final response = await http.get(
    'https://api.mrthn.dev/user/' + mrthnID + '/distance/over-period?date=' + date + '&period=30d&largestOnly=false',
      headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxIiwiaXNzIjoiTWFyYXRob24ifQ.1iZiWav2Ya6-jvQLkzQzoOuGCzjBK56R8pAiqnkF2UU"},
    );
    if (response.body.contains("error")) return '0';
    return compute(parseValue, response.body);
  }

  static String parseValue(String responseBody) {
    
    var responseJson = json.decode(responseBody);
    try {
      var result = responseJson['result'];
      print(result[0]['value'].toString());
      return result[0]['value'].toString();

    } catch (e) {
      return '0';
    }
    
    
  }

}