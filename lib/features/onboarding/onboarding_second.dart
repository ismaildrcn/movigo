import 'package:flutter/material.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/features/onboarding/utils/bottom_card.dart';
import 'dart:async';
import 'dart:math';

class OnboardingSecond extends StatefulWidget {
  const OnboardingSecond({super.key});

  @override
  State<OnboardingSecond> createState() => _OnboardingSecondState();
}

class _OnboardingSecondState extends State<OnboardingSecond> {
  final List<Map<String, double>> positions = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // İlk pozisyonları ayarla
    positions.addAll([
      {'top': 60, 'left': 75}, // HD icon
      {'top': 120, 'left': 32}, // İlk küçük daire
      {'top': 400, 'left': 60}, // İkinci küçük daire
      {'top': 70, 'right': 120}, // Üçüncü küçük daire
      {'top': 150, 'right': 50}, // Dördüncü küçük daire
      {'top': 250, 'right': 32}, // Beşinci küçük daire
      {'top': 410, 'right': 50}, // Download icon
    ]);
    final initialPositions = positions
        .map((p) => Map<String, double>.from(p))
        .toList();
    // Her 2 saniyede bir pozisyonları güncelle
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        for (var i = 0; i < positions.length; i++) {
          var position = positions[i];
          var initial = initialPositions[i];

          // Her parçacık başlangıç pozisyonundan en fazla 5 piksel uzaklaşabilir
          position['top'] = initial['top']! + (Random().nextDouble() * 10 - 5);

          if (position.containsKey('left')) {
            position['left'] =
                initial['left']! + (Random().nextDouble() * 10 - 5);
          } else {
            position['right'] =
                initial['right']! + (Random().nextDouble() * 10 - 5);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(
              milliseconds: 1500,
            ), // 2 saniye yerine 1.5 saniye
            curve: Curves.easeInOut,
            top: positions[0]['top'],
            left: positions[0]['left'],
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(Icons.hd, color: Colors.white, size: 24),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[1]['top'],
            left: positions[1]['left'],
            width: 20,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[2]['top'],
            left: positions[2]['left'],
            width: 20,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(104),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[3]['top'],
            right: positions[3]['right'],
            width: 15,
            height: 15,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(216),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[4]['top'],
            right: positions[4]['right'],
            width: 15,
            height: 15,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(168),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[5]['top'],
            right: positions[5]['right'],
            width: 10,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(104),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[6]['top'],
            right: positions[6]['right'],
            width: 30,
            height: 30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          Positioned(
            top: 70,
            left: 32,
            right: 32,
            child: Container(
              constraints: BoxConstraints(maxHeight: 350),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/onboarding_second.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),

          OnboardingBottomCard(
            title: "Offers ad-free viewing of high quality",
            description:
                "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
            currentState: AppRoutes.onboardingSecond,
            route: AppRoutes.onboardingThird,
          ),
        ],
      ),
    );
  }
}
