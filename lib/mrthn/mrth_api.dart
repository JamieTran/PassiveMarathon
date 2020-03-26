import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class MrthnAPI {
  static Future<http.Response> fetchSteps() async {
    // TODO: make user & date dynamic for what is being requested
    // TODO: also make authentication token private
    final response = await http.get(
    'https://marathon-web-api-staging.herokuapp.com/user/1/steps?date=2020-03-15',
      headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI2IiwiaXNzIjoiTWFyYXRob24ifQ.PY_7DnSqhgvromUG8x7JSUJl2AdA8sR14vFcaz-vtMM"},
    );
    print(response);
    final responseJson = json.decode(response.body);

    print(responseJson);

  }

}