import 'package:flutter/material.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/features/onboarding/utils/bottom_card.dart';
import 'dart:async';
import 'dart:math';

class OnboardingThird extends StatefulWidget {
  const OnboardingThird({super.key});

  @override
  State<OnboardingThird> createState() => _OnboardingThirdState();
}

class _OnboardingThirdState extends State<OnboardingThird> {
  final List<Map<String, double>> positions = [];
  final List<Map<String, double>> initialPositions = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // İlk pozisyonları ayarla
    positions.addAll([
      {'top': 60, 'left': 75}, // İlk daire
      {'top': 400, 'left': 60}, // İkinci daire
      {'top': 70, 'right': 120}, // Üçüncü daire
      {'top': 150, 'right': 50}, // Dördüncü daire
      {'top': 250, 'right': 32}, // Beşinci daire
      {'top': 146, 'left': 42}, // Rating kutusu
      {'top': 310, 'right': 42}, // Duration kutusu
    ]);

    // Başlangıç pozisyonlarını kaydet
    initialPositions.addAll(
      positions.map((p) => Map<String, double>.from(p)).toList(),
    );

    // Her 2 saniyede bir pozisyonları güncelle
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        for (var i = 0; i < positions.length; i++) {
          var position = positions[i];
          var initial = initialPositions[i];

          // Her parçacık için 10x10'luk bir alanda random hareket
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
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[0]['top'],
            left: positions[0]['left'],
            width: 25,
            height: 25,
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
            top: positions[1]['top'],
            left: positions[1]['left'],
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
            top: positions[2]['top'],
            right: positions[2]['right'],
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
            top: positions[3]['top'],
            right: positions[3]['right'],
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
            top: positions[4]['top'],
            right: positions[4]['right'],
            width: 10,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withAlpha(104),
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
                  image: AssetImage("assets/img/onboarding_third.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[5]['top'],
            left: positions[5]['left'],
            width: 80,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onSurface,
              ),
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text("Rating", style: TextStyle(color: Colors.white30)),
                  Text(
                    "9 / 10",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: positions[6]['top'],
            right: positions[6]['right'],
            width: 80,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onSurface,
              ),
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_filled_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text("Duration", style: TextStyle(color: Colors.white30)),
                  Text(
                    "1h 20m",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          OnboardingBottomCard(
            title: "Our service brings together your favorite series",
            description:
                "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
            currentState: AppRoutes.onboardingThird,
            route: AppRoutes.login,
          ),
        ],
      ),
    );
  }
}
