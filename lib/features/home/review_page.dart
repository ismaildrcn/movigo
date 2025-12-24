import 'package:flutter/material.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/movie/review_model.dart';
import 'package:movigo/data/services/reviews_service.dart';
import 'package:movigo/features/home/widgets/review_card.dart';

class ReviewPage extends StatefulWidget {
  final int id;
  const ReviewPage({super.key, required this.id});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final ReviewsService _reviewsService;
  ReviewsModel? reviews;

  @override
  void initState() {
    super.initState();
    _reviewsService = ReviewsService();
    loadData();
  }

  Future<void> loadData() async {
    final response = await _reviewsService.fetchReviews(widget.id);
    setState(() {
      reviews = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reviews == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  TopBar(
                    title: "Comments",
                    callback: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemCount: reviews!.reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews!.reviews[index];
                        return ReviewCard(
                          review: review,
                          width: double.infinity,
                          isReviewExpanded: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
