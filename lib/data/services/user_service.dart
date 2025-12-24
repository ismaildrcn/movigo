import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:movigo/data/datasources/remote.dart';

class UserService {
  final _dio = ApiService.instance;

  Future<Response?> updateUserDetails(Map<String, dynamic> details) async {
    try {
      final response = await _dio.patch(
        '/users/${details['id']}',
        data: details,
      );
      return response;
    } catch (e) {
      debugPrint("Error updating user details: $e");
      return null;
    }
  }

  Future<Response?> getWishlist(int userId) async {
    try {
      final response = await _dio.get('/users/$userId/wishlist');
      return response;
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
      return null;
    }
  }

  Future<Response?> addToWishlist(int userId, int movieId) async {
    try {
      final response = await _dio.post(
        '/users/$userId/wishlist',
        data: {'movie_id': movieId},
      );
      return response;
    } catch (e) {
      debugPrint("Error adding to wishlist: $e");
      return null;
    }
  }

  Future<Response?> removeFromWishlist(int userId, int movieId) async {
    try {
      final response = await _dio.delete('/users/$userId/wishlist/$movieId');
      return response;
    } catch (e) {
      debugPrint("Error removing from wishlist: $e");
      return null;
    }
  }
}
