import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api_key.dart';
import '../models/movie_detail_model.dart';
import '../models/the_movie_model.dart';

class TheMovieService {
  final baseUrl = "https://api.themoviedb.org/3/movie";

  Future<TheMovie> read() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl/now_playing?language=en-US&page=1&api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(theMovieFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MovieDetail> get(String movieId) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl/$movieId?language=en-US&api_key=$apiKey"),
      );
      if (response.statusCode == 200) {
        return compute(movieDetailFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
