import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/auth_service.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';
import 'package:movie_assistant/widgets/movie_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Movie> _watchlistMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWatchlistMovies();
  }

  Future<void> _fetchWatchlistMovies() async {
    try {
      final authService = AuthService();
      String? userId = await authService.getCurrentUserId();
      if (userId != null) {
        List<Movie> movies = await BackendService(Constants.baseUrl).fetchWatchlistMovies(userId);
        setState(() {
          _watchlistMovies = movies;
          _isLoading = false;
        });
      } else {
        throw Exception('User ID is null');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _watchlistMovies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: _watchlistMovies[index]);
              },
            ),
    );
  }
}
