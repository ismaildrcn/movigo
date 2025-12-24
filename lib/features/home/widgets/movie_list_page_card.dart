import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:intl/intl.dart';

class MovieListPageCard extends StatelessWidget {
  final MovieModel movie;
  const MovieListPageCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double? voteAverage;
    voteAverage = movie.voteAverage! / 2;
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        spacing: 20,
        children: [
          Stack(
            children: [
              Container(
                width: 132,
                height: 177,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageHelper.getImage(
                      movie.posterPath,
                      ApiConstants.posterSize.l,
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 6,
                      ),
                      color: Colors.white.withAlpha(48),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rate_rounded, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            voteAverage.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 145,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Expanded(
                    child: Text(
                      movie.originalTitle!.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.grey[500],
                      ),
                      Text(
                        movie.releaseDate != null
                            ? DateFormat('MMM yyyy').format(movie.releaseDate!)
                            : 'N/A',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.access_time_filled, color: Colors.grey[500]),
                      Text(
                        "${movie.runtime.toString()} Minutes",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.movie_creation_outlined,
                        color: Colors.grey[500],
                      ),
                      Text(
                        movie.genres!.isNotEmpty
                            ? movie.genres![0].name.toString()
                            : "Unknown",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      SizedBox(width: 12),
                      Text(
                        movie.originalLanguage.toString().toUpperCase(),
                        style: TextStyle(color: Colors.grey[500]),
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
}
