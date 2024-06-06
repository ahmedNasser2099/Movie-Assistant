import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/auth_service.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';

class PreferencesScreen extends StatefulWidget {
  final List<String> preferredGenres;

  const PreferencesScreen({super.key, required this.preferredGenres});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<Movie> _movies = [];
  final List<String> _selectedMovies = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMoviesByGenres();
  }

  Future<void> _fetchMoviesByGenres() async {
    try {
      List<Movie> movies = await BackendService(Constants.baseUrl).fetchMoviesByGenres(widget.preferredGenres);
      setState(() {
        _movies = movies;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch movies. Please try again later.';
      });
      print(e);
    }
  }

  void _toggleSelection(String movieId) {
    setState(() {
      if (_selectedMovies.contains(movieId)) {
        _selectedMovies.remove(movieId);
      } else {
        _selectedMovies.add(movieId);
      }
    });
  }

  Future<void> _submitPreferences() async {
    if (_selectedMovies.length < 3) {
      setState(() {
        _error = 'Please select at least 3 movies.';
      });
      return;
    }

    try {
      final authService = AuthService();
      String? userId = await authService.getCurrentUserId();

      if (userId != null) {
        await BackendService(Constants.baseUrl).saveUserPreferences(userId, _selectedMovies);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Failed to retrieve user ID';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save preferences. Please try again later.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Favorite Movies'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          final movie = _movies[index];
                          final isSelected = _selectedMovies.contains(movie.id);
                          return GestureDetector(
                            onTap: () => _toggleSelection(movie.id),
                            child: Card(
                              color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.white,
                              child: Column(
                                children: [
                                  Image.network(movie.posterUrl, height: 150, fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      movie.title,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _submitPreferences,
                        child: const Text('Submit Preferences'),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
    );
  }
}
