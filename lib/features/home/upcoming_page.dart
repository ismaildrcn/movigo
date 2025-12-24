import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/data/services/genre_service.dart';
import 'package:movigo/features/home/utils/image_utils.dart';

class UpcomingPage extends StatefulWidget {
  final List<MovieModel> movies;
  const UpcomingPage({super.key, required this.movies});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  late final GenreService _genreService;
  List<Genres> _genres = [];
  List<MovieModel> showedMovies = [];

  int current = 0;
  List<Genres> allGenresObject = [
    Genres.fromJson({"id": 999, "name": "All"}),
  ];

  @override
  void initState() {
    super.initState();
    _genreService = GenreService();
    loadData();
  }

  Future<void> loadData() async {
    final genres = await _genreService.fetchGenres();

    setState(() {
      showedMovies = widget.movies;
      _genres = allGenresObject + genres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: "Upcoming Movie", callback: () => context.pop()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  spacing: 10,
                  children: [
                    _genreSelectionField(),

                    Expanded(
                      child: ListView.builder(
                        itemCount: showedMovies.length,
                        itemBuilder: (context, index) {
                          return _upcomingMovieContent(showedMovies[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _genreSelectionField() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
                if (index == 0) {
                  showedMovies = widget.movies;
                } else {
                  showedMovies = widget.movies
                      .where(
                        (element) =>
                            element.genreIds!.first == _genres[index].id,
                      )
                      .toList();
                }
              });
            },
            child: Container(
              constraints: BoxConstraints(minWidth: 100),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: current == index
                    ? Theme.of(context).colorScheme.onSurface
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _genres[index].name,
                style: TextStyle(
                  fontSize: 16,
                  color: current == index
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _upcomingMovieContent(MovieModel? movie) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              image: DecorationImage(
                image: ImageHelper.getImage(
                  movie!.backdropPath,
                  ApiConstants.posterSize.original,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onTap: () => context.push("/movie/${movie.id}", extra: true),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(50),
                    maxRadius: 30,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            movie.originalTitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            spacing: 12,
            children: [
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 22,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    "March 2, 2022",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),

              SizedBox(
                height: 18,
                child: VerticalDivider(
                  thickness: 2,
                  color: Colors.grey.shade500,
                ),
              ),

              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.local_movies_rounded,
                    size: 22,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    movie.genreIds != null && movie.genreIds!.isNotEmpty
                        ? _genres
                              .firstWhere(
                                (e) => e.id == movie.genreIds!.first,
                                orElse: () =>
                                    Genres(id: -1, name: 'Unknown Genre'),
                              )
                              .name
                        : 'No Genres',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
