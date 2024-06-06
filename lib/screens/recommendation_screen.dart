import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/auth_service.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';
import 'package:movie_assistant/widgets/movie_card.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<Movie> _recommendedMovies = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRecommendedMovies();
  }

  Future<void> _fetchRecommendedMovies() async {
    try {
      final authService = AuthService();
      String? userId = await authService.getCurrentUserId();
      List<Movie> movies = await BackendService(Constants.baseUrl).fetchRecommendedMovies(userId!);
      setState(() {
        _recommendedMovies = movies;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch recommended movies. Please try again later.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Movies'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _recommendedMovies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: _recommendedMovies[index]);
                  },
                ),
    );
  }
}
