import 'dart:convert';

import 'package:movigo/data/model/user/user_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movigo/features/profile/utils/auth_response.dart';

class SecureStorage {
  static const _userKey = 'user';
  static const _tokenKey = 'token';

  static final storage = FlutterSecureStorage();

  static Future<void> saveUser(AuthResponse response) async {
    await storage.write(key: _tokenKey, value: response.token);
    await storage.write(
      key: _userKey,
      value: jsonEncode(response.user.toJson()),
    );
  }

  static Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  static Future<UserModel?> getUser() async {
    final token = await storage.read(key: _tokenKey);
    final user = await storage.read(key: _userKey);

    if (token == null || user == null) return null;

    return UserModel.fromJson(jsonDecode(user));
  }

  static Future<void> clearAll() async {
    await storage.deleteAll();
  }

  static FlutterSecureStorage get instance => storage;
}
