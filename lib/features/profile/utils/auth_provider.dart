import 'package:flutter/material.dart';
import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/model/user/user_model.dart';
import 'package:movigo/features/profile/utils/auth_response.dart';
import 'package:movigo/features/profile/utils/storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _user;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get user => _user;

  Future<void> checkAuthStatus() async {
    _user = await SecureStorage.getUser();
    _isAuthenticated = _user != null;
    // İlk açılışta auth kontrolünde user varsa token interceptor ekle
    if (_isAuthenticated) {
      ApiService.addTokenInterceptor();
    }
    notifyListeners();
  }

  Future<void> login(AuthResponse response) async {
    await SecureStorage.saveUser(response);
    _user = response.user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await SecureStorage.instance.deleteAll();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
