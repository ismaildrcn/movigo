import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/video_model.dart';

class VideoService {
  final _dio = ApiService.instance;

  Future<Videos> fetchVideos(movieId) async {
    // try {
    // cast ve crew olmak üzere tüm datalar mevcut
    final response = await _dio.get('/remote/movie/$movieId/videos');
    return Videos.fromJson(response.data);
    // } catch (e) {
    //   rethrow;
    // }
  }
}
