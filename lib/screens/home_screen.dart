import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/google_signin_service.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';
import 'package:movie_assistant/widgets/movie_carousel.dart';
import 'package:movie_assistant/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> recommendedMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> arabicMovies = [];

  final BackendService movieService = BackendService(Constants.baseUrl);
  final TextEditingController searchController = TextEditingController();
  late Future<String?> userIdFuture = GoogleSignInService().getCurrentUserId();

  @override
  void initState() {
    super.initState();
    userIdFuture = GoogleSignInService().getCurrentUserId();
    bool isAnonymousUser() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null && user.isAnonymous;
}
  }

  Future<void> _fetchMovies(String userId) async {
    recommendedMovies = await movieService.fetchRecommendedMovies(userId);
    topRatedMovies = await movieService.fetchMoviesByCategory('top-rated');
    trendingMovies = await movieService.fetchMoviesByCategory('trending');
    upcomingMovies = await movieService.fetchMoviesByCategory('upcoming');
    arabicMovies = await movieService.fetchMoviesByCategory('arabic');
    setState(() {});
  }

  void _onSearch() {
    Navigator.pushNamed(context, '/search');
  }

  Widget _buildMovieSection(String title, List<Movie> movies, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/recommendations', arguments: category);
                },
                child: Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(movie.posterUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie.title,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    await GoogleSignInService().signOutFromGoogle();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: userIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(child: Text('No user ID found')),
          );
        } else {
          String userId = snapshot.data!;
          _fetchMovies(userId);
          return Scaffold(
            appBar: AppBar(
              title: Text('Movie Assistant'),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: searchBar(
                  controller: searchController,
                  onSearch: _onSearch,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  MovieCarousel(userId: userId),
                  _buildMovieSection('Top Rated Movies', topRatedMovies, 'top-rated'),
                  _buildMovieSection('Trending Movies', trendingMovies, 'trending'),
                  _buildMovieSection('Upcoming Movies', upcomingMovies, 'upcoming'),
                  _buildMovieSection('Arabic Movies', arabicMovies, 'arabic'),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Account'),
                    children: [
                      ListTile(
                        title: Text('Edit Email'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Edit Password'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('General'),
                    children: [
                      ListTile(
                        title: Text('Theme'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Language'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Logout'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: Icon(Icons.assistant),
            ),
          );
        }
      },
    );
  }
}
