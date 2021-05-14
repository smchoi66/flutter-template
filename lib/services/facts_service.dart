import 'dart:convert';

import 'package:flutter_basic/models/facts_response.dart';
import 'package:http/http.dart' as http;

class FactsService {
  Future<FactsResponse?> getFacts() async {
    http.Response response;
    response = await http
        .get(Uri.parse('https://thegrowingdeveloper.org/apiview?id=2'));

    if (response.statusCode == 200) {
      return FactsResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
