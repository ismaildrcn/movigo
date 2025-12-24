import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/user/user_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/data/services/user_service.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:movigo/data/model/movie/movie_model.dart';
import 'package:movigo/features/profile/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  UserService userService = UserService();
  UserModel? currentUser;
  List<MovieModel> wishlistItems = [];
  AuthProvider authProvider = AuthProvider();
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentUser = authProvider.user;
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final response = await userService.getWishlist(currentUser!.id!);
    if (!mounted) return;
    if (response != null) {
      setState(() {
        wishlistItems = (response.data ?? [])
            .map<MovieModel>((item) => MovieModel.fromJson(item))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: "Wishlist", showBackButton: false),
            wishlistItems.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      padding: EdgeInsets.all(18),
                      itemCount: wishlistItems.length,
                      itemBuilder: (context, index) {
                        final movie = wishlistItems[index];
                        return wishlistCard(context, movie);
                      },
                    ),
                  )
                : noMovieContainer(),
          ],
        ),
      ),
    );
  }

  Expanded noMovieContainer() {
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 230),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/img/magic-box.png", width: 76, height: 76),
              SizedBox(height: 16),
              Text(
                "There is no movie yet!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Find your movie by Type title, categories, years, etc.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container wishlistCard(BuildContext context, MovieModel movie) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withAlpha(240),
          ],
        ),
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
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -22,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withAlpha(15),
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: Theme.of(context).colorScheme.primary.withAlpha(50),
                  size: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.push("/movie/${movie.id}"),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  spacing: 16,
                  children: [
                    Container(
                      width: 120,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ImageHelper.getImage(
                            movie.posterPath,
                            ApiConstants.posterSize.m,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            movie.genres![0].name,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.titleSmall!.color,
                            ),
                          ),
                          Text(
                            movie.title ?? "Title",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Movie",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleSmall!.color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                (movie.voteAverage! / 2).toStringAsFixed(1),
                                style: TextStyle(color: Colors.yellow),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
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
}
