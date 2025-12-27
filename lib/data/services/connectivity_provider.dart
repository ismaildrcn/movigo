import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movigo/data/services/connectivity_service.dart';

/// Bağlantı durumunu yöneten Provider
class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription<bool>? _subscription;

  ConnectivityProvider() {
    _initialize();
  }

  void _initialize() {
    // Servis zaten main'de initialize edildi, mevcut durumu al
    _isConnected = _connectivityService.isConnected;

    // Bağlantı değişikliklerini dinle
    _subscription = _connectivityService.connectionStream.listen((isConnected) {
      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// Manuel olarak bağlantıyı kontrol et
  Future<bool> checkConnection() async {
    final result = await _connectivityService.checkConnection();
    if (_isConnected != result) {
      _isConnected = result;
      notifyListeners();
    }
    return result;
  }

  /// Yeniden bağlanmayı dene
  Future<bool> retryConnection() async {
    return await checkConnection();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
