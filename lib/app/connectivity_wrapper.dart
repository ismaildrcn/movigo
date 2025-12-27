import 'package:flutter/material.dart';
import 'package:movigo/data/services/connectivity_provider.dart';
import 'package:movigo/features/general/no_wifi.dart';
import 'package:provider/provider.dart';

/// Bağlantı durumuna göre içeriği veya NoWifiPage'i gösteren wrapper
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        // İnternet bağlantısı yoksa NoWifiPage göster
        if (!connectivity.isConnected) {
          return const NoWifiPage();
        }
        return child;
      },
    );
  }
}

/// Alternatif: Stack ile overlay olarak gösterim
/// Bu widget mevcut sayfanın üzerine NoWifiPage'i overlay olarak gösterir
class ConnectivityOverlay extends StatelessWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        return Stack(
          children: [
            child,
            // Bağlantı yoksa üzerine NoWifiPage ekle
            if (!connectivity.isConnected)
              Positioned.fill(child: const NoWifiPage()),
          ],
        );
      },
    );
  }
}
