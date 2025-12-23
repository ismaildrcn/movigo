import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:imdb_app/data/datasources/remote.dart';
import 'package:imdb_app/data/model/user/user_model.dart';

class AuthService {
  final _dio = ApiService.instance;

  Future<Response?> createUser(UserModel user) async {
    try {
      Map<String, dynamic> userData = {
        'full_name': user.fullName,
        'email': user.email,
        'password': user.password,
        'birth_date': user.birthdate,
        'gender': user.gender.toString().split('.').last,
      };
      final response = await _dio.post('/auth/register', data: userData);
      return response;
    } catch (e) {
      debugPrint("Error creating user: $e");
      return null;
    }
  }

  Future<Response?> signInUser(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      debugPrint("Error signing in user: $e");
      return null;
    }
  }
}
