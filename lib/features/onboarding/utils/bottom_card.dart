import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';

class OnboardingBottomCard extends StatelessWidget {
  final String title;
  final String description;
  final String currentState;
  final String route;

  const OnboardingBottomCard({
    super.key,
    required this.title,
    required this.description,
    required this.currentState,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),

              // Dots indicator
              Row(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Container(
                        width: currentState == AppRoutes.onboardingFirst
                            ? 32
                            : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentState == AppRoutes.onboardingFirst
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(104),
                        ),
                      ),
                      Container(
                        width: currentState == AppRoutes.onboardingSecond
                            ? 32
                            : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentState == AppRoutes.onboardingSecond
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(104),
                        ),
                      ),
                      Container(
                        width: currentState == AppRoutes.onboardingThird
                            ? 32
                            : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentState == AppRoutes.onboardingThird
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(104),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.push(route);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(child: Icon(Icons.arrow_forward_ios)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
