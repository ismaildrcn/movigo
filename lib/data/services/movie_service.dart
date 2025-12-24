import 'package:dio/dio.dart';
import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/movie_model.dart';

class MovieTypes {
  static const String topRated = "top_rated";
  static const String popular = "popular";
  static const String nowPlaying = "now_playing";
  static const String upcoming = "upcoming";
}

class MovieService {
  final _dio = ApiService.instance;

  Future<List<MovieModel>> fetchMovies({required String type}) async {
    try {
      final url = '/remote/movie/$type';
      final response = await _dio.get(url);
      return (response.data["results"] as List)
          .map((e) => MovieModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> fetchTrendingMovies({required String type}) async {
    try {
      final url = '/remote/trending/movie';
      final response = await _dio.get(url);
      return (response.data["results"] as List)
          .map((e) => MovieModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> fetchMoviesWithoutToken({
    required String type,
  }) async {
    try {
      final url = '/remote/movie/$type/without-token';
      final response = await _dio.get(url);
      return (response.data["results"] as List)
          .map((e) => MovieModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieModel> fetchMovie(
    int movieId, {
    int? userId,
    String language = 'en-US',
  }) async {
    try {
      final response = await _dio.get(
        '/remote/movie/$movieId',
        queryParameters: {if (userId != null) 'user_id': userId},
      );
      return MovieModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> searchMovies({required String searchText}) async {
    List<MovieModel> movies = [];
    try {
      final response = await _dio.get(
        '/remote/search/movie',
        queryParameters: {'query': searchText},
        options: Options(
          sendTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 20),
        ),
      );
      if (response.data["results"] == null) {
        return [];
      }
      movies = (response.data["results"] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // voteAverage'a göre azalan sırada sırala
      movies.sort((a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0));

      return movies;
    } catch (e) {
      rethrow;
    }
  }
}
