import 'package:flutter/material.dart';
import 'package:movigo/data/model/movie/review_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final double width;
  final bool isReviewExpanded;
  final double? height;
  final bool isDialog;

  const ReviewCard({
    super.key,
    required this.review,
    required this.width,
    this.isReviewExpanded = false,
    this.height,
    this.isDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    final rating = review.authorDetails!.rating;
    final hasRating = rating != null;

    return Container(
      width: width,
      constraints: isDialog ? BoxConstraints(maxHeight: height ?? 400) : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withAlpha(240),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative accent
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withAlpha(15),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with avatar and rating
                  Row(
                    children: [
                      // Avatar with gradient border
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          backgroundImage:
                              review.authorDetails!.avatarPath != null
                              ? ImageHelper.getImage(
                                  review.authorDetails!.avatarPath,
                                  ApiConstants.posterSize.m,
                                )
                              : null,
                          child: review.authorDetails!.avatarPath == null
                              ? Icon(
                                  Icons.person_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      // Name and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.authorDetails!.name == ""
                                  ? review.author ?? "Anonymous"
                                  : review.authorDetails!.name.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              review.createdAt != null
                                  ? DateFormat(
                                      "MMM d, yyyy",
                                    ).format(review.createdAt!)
                                  : "Unknown date",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color!.withAlpha(220),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rating badge
                      if (hasRating)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber[700],
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Quote icon
                  Icon(
                    Icons.format_quote_rounded,
                    color: Theme.of(context).colorScheme.primary.withAlpha(80),
                    size: 24,
                  ),
                  SizedBox(height: 8),
                  // Review content
                  if (isReviewExpanded)
                    Text(
                      review.content.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.color!.withAlpha(220),
                      ),
                    )
                  else if (isDialog)
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          review.content.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color!.withAlpha(220),
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      review.content.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.color!.withAlpha(220),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
