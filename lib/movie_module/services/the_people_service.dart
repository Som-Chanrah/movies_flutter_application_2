import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api_key.dart';
import '../models/person_model.dart';

class ThePeopleService {
  final baseUrl = "https://api.themoviedb.org/3/person";

  Future<PopularPeople> readPopular() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl/popular?language=en-US&page=1&api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(popularPeopleFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PersonDetail> get(String personId) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl/$personId?language=en-US&api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(personDetailFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
