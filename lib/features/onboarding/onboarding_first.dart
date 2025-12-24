import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/data/services/movie_service.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:movigo/features/onboarding/utils/bottom_card.dart';

class OnboardingFirst extends StatefulWidget {
  const OnboardingFirst({super.key});

  @override
  State<OnboardingFirst> createState() => _OnboardingFirstState();
}

class _OnboardingFirstState extends State<OnboardingFirst> {
  MovieService movieService = MovieService();
  List<MovieModel> movies = [];
  bool showOddIndexes = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadData();
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void loadData() async {
    final _movies = await movieService.fetchMoviesWithoutToken(type: MovieTypes.nowPlaying);
    if (!mounted) return;
    setState(() {
      movies = _movies;
    });
  }

  void _startAnimation() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel(); // Cancel timer if widget is not mounted
        return;
      }
      setState(() {
        showOddIndexes = !showOddIndexes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Transform.scale(
                    scale: 1.3,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 700),
                            opacity: showOddIndexes
                                ? (index % 2 == 1 ? 1.0 : 0.15)
                                : (index % 2 == 0 ? 1.0 : 0.15),
                            child: Container(
                              height: 150,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: ImageHelper.getImage(
                                    movie.posterPath,
                                    ApiConstants.posterSize.l,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                OnboardingBottomCard(
                  title: "The biggest international and local film streaming",
                  description:
                      "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
                  currentState: AppRoutes.onboardingFirst,
                  route: AppRoutes.onboardingSecond,
                ),
              ],
            ),
    );
  }
}
