import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/movie_model.dart';

class GenreService {
  final _dio = ApiService.instance;

  Future<List<Genres>> fetchGenres() async {
    // try {
    final response = await _dio.get('/remote/genre/movie/list');
    return (response.data['genres'] as List)
        .map((e) => Genres.fromJson(e))
        .toList();
    // } catch (e) {
    //   rethrow;
    // }
  }
}
