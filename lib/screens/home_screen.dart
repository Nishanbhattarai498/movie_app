import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_section.dart';
import '../widgets/featured_movie.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../providers/watch_history_provider.dart';
import '../widgets/continue_watching_card.dart';
import 'continue_watching_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeTab(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineMax'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.trendingMovies.isNotEmpty) {
                  return FeaturedMovie(
                    movie: movieProvider.trendingMovies.first,
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 20),
            Consumer<WatchHistoryProvider>(
              builder: (context, watchHistoryProvider, child) {
                final movieProvider = Provider.of<MovieProvider>(
                  context,
                  listen: false,
                );
                final continueWatching = watchHistoryProvider.watchHistory
                    .where((progress) => !progress.isCompleted)
                    .take(5)
                    .toList();

                if (continueWatching.isEmpty) return SizedBox.shrink();

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Continue Watching',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContinueWatchingScreen(),
                                ),
                              );
                            },
                            child: Text('See All'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: continueWatching.length,
                        itemBuilder: (context, index) {
                          final progress = continueWatching[index];
                          final movie = movieProvider.getMovieById(
                            progress.movieId,
                          );

                          if (movie == null) return SizedBox.shrink();

                          return Container(
                            width: 120,
                            margin: EdgeInsets.only(right: 12),
                            child: ContinueWatchingCard(
                              movie: movie,
                              progress: progress,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
            Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                return Column(
                  children: [
                    MovieSection(
                      title: 'Trending Now',
                      movies: movieProvider.trendingMovies,
                    ),
                    SizedBox(height: 20),
                    MovieSection(
                      title: 'Popular Movies',
                      movies: movieProvider.popularMovies,
                    ),
                    SizedBox(height: 20),
                    MovieSection(
                      title: 'Coming Soon',
                      movies: movieProvider.upcomingMovies,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
