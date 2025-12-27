import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// İnternet bağlantısı durumunu yöneten servis
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  // Bağlantı durumu stream controller
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionStatusController.stream;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Servisi başlatır ve bağlantı değişikliklerini dinlemeye başlar
  Future<void> initialize() async {
    if (_isInitialized) return;

    // İlk bağlantı durumunu kontrol et
    await checkConnection();

    // Bağlantı değişikliklerini dinle
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    _isInitialized = true;
  }

  /// Bağlantı durumunu günceller
  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    // Önce ağ bağlantısı var mı kontrol et
    final hasNetworkConnection =
        results.isNotEmpty &&
        !results.every((result) => result == ConnectivityResult.none);

    if (!hasNetworkConnection) {
      // Ağ bağlantısı yok
      if (_isConnected) {
        _isConnected = false;
        _connectionStatusController.add(false);
      }
      return;
    }

    // Ağ bağlantısı var, gerçek internet erişimini kontrol et
    final hasInternet = await _hasRealInternetConnection();

    if (_isConnected != hasInternet) {
      _isConnected = hasInternet;
      _connectionStatusController.add(hasInternet);
    }
  }

  /// Gerçek internet bağlantısını kontrol eder (DNS lookup ile)
  Future<bool> _hasRealInternetConnection() async {
    try {
      // Google DNS'e lookup yaparak gerçek internet erişimini test et
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Mevcut bağlantı durumunu kontrol eder
  Future<bool> checkConnection() async {
    try {
      // Önce ağ bağlantısını kontrol et
      final results = await _connectivity.checkConnectivity();
      final hasNetworkConnection =
          results.isNotEmpty &&
          !results.every((result) => result == ConnectivityResult.none);

      if (!hasNetworkConnection) {
        _isConnected = false;
        _connectionStatusController.add(false);
        return false;
      }

      // Ağ var, gerçek internet erişimini kontrol et
      final hasInternet = await _hasRealInternetConnection();
      _isConnected = hasInternet;
      _connectionStatusController.add(hasInternet);
      return hasInternet;
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
      return false;
    }
  }

  /// Bağlantı durumunu false olarak işaretle (Dio hatası sonrası)
  void markDisconnected() {
    if (_isConnected) {
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  /// Servisi temizler
  void dispose() {
    _subscription?.cancel();
    _connectionStatusController.close();
  }
}

/// Dio için bağlantı kontrol interceptor'ı
class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  ConnectivityInterceptor(this._connectivityService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Servis initialize olmamışsa bekle
    if (!_connectivityService.isInitialized) {
      await _connectivityService.initialize();
    }

    // Bağlantı yoksa hata fırlat
    if (!_connectivityService.isConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: NoInternetException('İnternet bağlantısı yok'),
        ),
      );
      return;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Bağlantı hatalarını yakala ve connectivity durumunu güncelle
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.error is NoInternetException) {
      // Bağlantı durumunu güncelle
      _connectivityService.markDisconnected();
    }
    handler.next(err);
  }
}

/// İnternet bağlantısı olmadığını belirten özel exception
class NoInternetException implements Exception {
  final String message;
  NoInternetException(this.message);

  @override
  String toString() => message;
}
