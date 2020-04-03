import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;


class MrthnAPI {
  static Future<http.Response> fetchSteps() async {
    // TODO: make user & date dynamic for what is being requested
    // TODO: also make authentication token private
    final response = await http.get(
    'https://api.mrthn.dev/user/' + Constants.user_id.toString() + '/distance?date=2020-03-30',
      headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxIiwiaXNzIjoiTWFyYXRob24ifQ.1iZiWav2Ya6-jvQLkzQzoOuGCzjBK56R8pAiqnkF2UU"},
    );
    print(response);
    final responseJson = json.decode(response.body);

    print(responseJson);

  }

}