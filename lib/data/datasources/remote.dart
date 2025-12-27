import 'package:dio/dio.dart';
import 'package:movigo/data/services/connectivity_service.dart';
import 'package:movigo/features/profile/utils/storage.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.100:8000";
  // static const String baseUrl ="https://imdb-app-backend-py.onrender.com";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "$baseUrl/v1/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null &&
            status < 500; // 500 ve üstü hataları exception yap
      },
    ),
  );

  static bool _interceptorsAdded = false;

  static void addTokenInterceptor() {
    if (_interceptorsAdded) return;
    _interceptorsAdded = true;

    // Connectivity interceptor ekle (ilk sırada olmalı)
    instance.interceptors.add(ConnectivityInterceptor(ConnectivityService()));

    // Token interceptor ekle
    instance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  static Dio get instance => _dio;
}
