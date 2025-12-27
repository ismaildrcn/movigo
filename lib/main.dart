import 'package:flutter/material.dart';
import 'package:movigo/app/connectivity_wrapper.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/app/theme.dart';
import 'package:movigo/app/theme_manager.dart';
import 'package:movigo/data/datasources/remote.dart';
import 'package:movigo/data/services/connectivity_provider.dart';
import 'package:movigo/data/services/connectivity_service.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connectivity servisini ilk olarak başlat
  await ConnectivityService().initialize();

  // API interceptor'ları ekle (connectivity interceptor dahil)
  ApiService.addTokenInterceptor();

  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus(); // Auth durumunu kontrol et

  // ConnectivityProvider'ı oluştur
  final connectivityProvider = ConnectivityProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider<ConnectivityProvider>.value(
          value: connectivityProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Movigo',
      theme: AppTheme.lightTheme, // Light tema
      darkTheme: AppTheme.darkTheme, // Dark tema
      themeMode: themeManager.themeMode, // Dinamik tema modu
      routerConfig: AppRouter(authProvider).router,
      builder: (context, child) {
        // Tüm uygulamayı ConnectivityWrapper ile sar
        return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
