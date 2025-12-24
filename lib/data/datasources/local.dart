import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:movigo/data/model/movie/movie_model.dart';

class MostPopularMoviesLocalDataSource {
  Future<List<MovieModel>> getMovies() async {
    final data = await rootBundle.loadString(
      'assets/json/most_popular_movies.json',
    );
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => MovieModel.fromJson(e)).toList();
  }
}

class MovieLocalDataSource {
  Future<MovieModel> getMovie() async {
    final data = await rootBundle.loadString('assets/json/movie_detail.json');
    final Map<String, dynamic> jsonMap = json.decode(data);
    return MovieModel.fromJson(jsonMap);
  }
}
