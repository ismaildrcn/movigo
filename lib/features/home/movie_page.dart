import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/router.dart';
import 'package:movigo/data/model/movie/credits_model.dart';
import 'package:movigo/data/model/movie/review_model.dart';
import 'package:movigo/data/model/movie/video_model.dart';
import 'package:movigo/data/model/user/user_model.dart';
import 'package:movigo/data/services/credits_service.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/data/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/data/services/reviews_service.dart';
import 'package:movigo/data/services/user_service.dart';
import 'package:movigo/data/services/video_service.dart';
import 'package:movigo/features/home/credits_page.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:movigo/features/home/widgets/review_card.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviePage extends StatefulWidget {
  final int movieId;
  final bool? hasVideo;
  const MoviePage({super.key, required this.movieId, this.hasVideo});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late final MovieService _movieService;
  late final CreditsService _creditsService;
  late final ReviewsService _reviewsService;
  late final VideoService _videoService;
  late final UserService _userService;
  UserModel? _currentUser;
  YoutubePlayerController? _youtubePlayerController;
  MovieModel? _movie;
  Credits? _credits;
  ReviewsModel? _reviews;
  Videos? _videos;
  double? voteAverage;
  bool isInWishlist = false;
  Future<void>? _loadDataFuture; // Nullable Future tanımla

  @override
  void initState() {
    super.initState();
    _movieService = MovieService();
    _creditsService = CreditsService();
    _reviewsService = ReviewsService();
    _videoService = VideoService();
    _userService = UserService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _currentUser = authProvider.user;
    _loadDataFuture = loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _loadDataFuture?.ignore();
    _youtubePlayerController?.dispose();
  }

  Future<void> loadData() async {
    final movie = await _movieService.fetchMovie(
      widget.movieId,
      userId: _currentUser?.id,
    );
    final credits = await _creditsService.fetchCredits(widget.movieId);
    if (widget.hasVideo == true) {
      final videos = await _videoService.fetchVideos(widget.movieId);
      _videos = videos;
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: _videos!.results[0].key ?? '',
        flags: YoutubePlayerFlags(autoPlay: false),
      );
    }
    setState(() {
      _movie = movie;
      _credits = credits;
      isInWishlist = movie.isInWishlist ?? false;
      voteAverage = _movie!.voteAverage! / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _movie == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _posterField(context),

                // Video
                if (widget.hasVideo == true)
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: Colors.black, // opsiyonel: arka plan rengi
                        child: YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: _youtubePlayerController!,
                          ),
                          builder: (context, player) {
                            return Column(children: [player]);
                          },
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _genresField(),

                      _overviewField(),

                      _castAndCrewField(context),

                      VisibilityDetector(
                        key: Key("reviews_visibility_detector"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction > 0 && _reviews == null) {
                            _reviewsService.fetchReviews(widget.movieId).then((
                              reviews,
                            ) {
                              setState(() {
                                _reviews = reviews;
                              });
                            });
                          }
                        },
                        child: _reviews == null
                            ? SizedBox(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : (_reviews!.reviews.isEmpty
                                  ? SizedBox()
                                  : _reviewsContainer()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  AspectRatio _posterField(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary.withAlpha(25),
              image: DecorationImage(
                image: ImageHelper.getImage(
                  _movie!.posterPath,
                  ApiConstants.posterSize.original,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface.withAlpha(255),
                    // Colors.transparent, // Üst kısım
                    Theme.of(context).colorScheme.surface.withAlpha(150),
                    Theme.of(context).colorScheme.surface.withAlpha(255),
                  ],
                ),
              ),
            ),
          ),

          // Top Action Button
          Positioned(
            child: Container(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 55),
              alignment: Alignment.topCenter,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withAlpha(64),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 30),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _movie!.originalTitle!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => checkIsInWishlist(context),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withAlpha(64),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: isInWishlist
                          ? Icon(Icons.bookmark, size: 30, color: Colors.red)
                          : Icon(Icons.bookmark_border, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 108,
            bottom: 80,
            left: 85,
            right: 85,
            child: Container(
              width: 205,
              height: 287,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: ImageHelper.getImage(
                    _movie!.posterPath,
                    ApiConstants.posterSize.original,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.grey[500],
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        DateFormat("yyyy").format(_movie!.releaseDate!),
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          border: BoxBorder.fromBorderSide(
                            BorderSide(color: Colors.grey, width: 0.3),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.access_time_filled,
                        color: Colors.grey[500],
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      _movie!.runtime == null
                          ? Text(
                              "N/A",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 18,
                              ),
                            )
                          : Text(
                              "${_movie!.runtime!.toString()} Minutes",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 18,
                              ),
                            ),
                      SizedBox(width: 10),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          border: BoxBorder.fromBorderSide(
                            BorderSide(color: Colors.grey, width: 0.3),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.movie_creation_outlined,
                        color: Colors.grey[500],
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _movie!.genres![0].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        voteAverage!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _genresField() {
    return SizedBox(
      width: double.infinity,
      height: 35,
      child: ListView.builder(
        itemCount: _movie!.genres!.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary.withAlpha(64),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _movie!.genres![index].name,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column _overviewField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Story Line",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Text(_movie!.overview!, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Column _castAndCrewField(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Cast and Crew",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.credits, extra: _credits);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.transparent),
              child: Text(
                "See all",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_credits!.cast.isEmpty)
          Text(
            "No cast information available.",
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.titleSmall!.color!.withAlpha(128),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(
                        context,
                      ).modalBarrierDismissLabel,
                      barrierColor: Colors.black54,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PersonDetailDialog(
                            personId: _credits!.cast[index].id,
                          ),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(
                                      0,
                                      1,
                                    ), // Aşağıdan başlar
                                    end: Offset.zero, // Ortada biter
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ImageHelper.getImage(
                                _credits!.cast[index].profilePath,
                                ApiConstants.posterSize.m,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _credits!.cast[index].character,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          _credits!.cast[index].originalName,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.titleSmall!.color!.withAlpha(128),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 5,
            ),
          ),
      ],
    );
  }

  Widget _reviewsContainer() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            TextButton(
              onPressed: () => context.push("/reviews/${widget.movieId}"),
              style: TextButton.styleFrom(foregroundColor: Colors.transparent),
              child: Text(
                "See all",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 16),
            itemCount: _reviews!.reviews.length >= 3
                ? 3
                : _reviews?.reviews.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(
                      context,
                    ).modalBarrierDismissLabel,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: ReviewCard(
                          review: _reviews!.reviews[index],
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.6,
                          isDialog: true,
                        ),
                      );
                    },
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 1), // Aşağıdan başlar
                                  end: Offset.zero, // Ortada biter
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                  ),
                },
                child: ReviewCard(review: _reviews!.reviews[index], width: 280),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> checkIsInWishlist(context) async {
    if (isInWishlist) {
      final response = await _userService.removeFromWishlist(
        _currentUser!.id!,
        _movie!.id,
      );
      if (response?.statusCode == 200) {
        AnimatedSnackBar.material(
          "Removed from wishlist",
          type: AnimatedSnackBarType.info,
        ).show(context);
        setState(() {
          isInWishlist = false;
        });
      } else {
        AnimatedSnackBar.material(
          "Failed to remove from wishlist",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    } else {
      final response = await _userService.addToWishlist(
        _currentUser!.id!,
        _movie!.id,
      );
      if (response?.statusCode == 200) {
        AnimatedSnackBar.material(
          "Added to wishlist",
          type: AnimatedSnackBarType.info,
        ).show(context);
        setState(() {
          isInWishlist = true;
        });
      } else {
        AnimatedSnackBar.material(
          "Failed to add to wishlist",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    }
  }
}
