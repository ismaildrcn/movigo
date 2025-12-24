import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/movie/person_model.dart';

class PersonService {
  final _dio = ApiService.instance;

  Future<PersonModel> fetchPerson({required int personId}) async {
    try {
      final response = await _dio.get('/remote/person/$personId');
      return PersonModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
