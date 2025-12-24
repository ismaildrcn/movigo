import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/credits_model.dart';

class CreditsService {
  final _dio = ApiService.instance;

  Future<Credits> fetchCredits(movieId) async {
    // try {
    // cast ve crew olmak üzere tüm datalar mevcut
    final response = await _dio.get('/remote/movie/$movieId/credits');
    return Credits.fromJson(response.data);
    // } catch (e) {
    //   rethrow;
    // }
  }
}
