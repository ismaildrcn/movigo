import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/review_model.dart';

class ReviewsService {
  final _dio = ApiService.instance;

  Future<ReviewsModel> fetchReviews(movieId) async {
    // try {
    // cast ve crew olmak üzere tüm datalar mevcut
    final response = await _dio.get('/remote/movie/$movieId/reviews');
    return ReviewsModel.fromJson(response.data);
    // } catch (e) {
    //   rethrow;
    // }
  }
}
