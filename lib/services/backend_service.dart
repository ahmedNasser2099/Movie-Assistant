import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';

class BackendService {
  final String baseUrl;

  BackendService(String baseUrl) : baseUrl = Constants.baseUrl;

  Future<List<Movie>> fetchMoviesByGenres(List<String> genres) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movie/popular'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'genres': genres}),
    );

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies by genres');
    }
  }

  Future<Movie> fetchMovieDetails(String movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movies/$movieId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> movieJson = jsonDecode(response.body);
      return Movie.fromJson(movieJson);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<void> saveUserPreferences(String userId, List<String> selectedMovies) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/preferences'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'selectedMovies': selectedMovies}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user preferences');
    }
  }

  Future<List<Movie>> fetchRecommendedMovies(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/recommendations'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recommended movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movies/search?query=$query'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<Movie>> fetchMoviesByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movies/category/$category'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies by category');
    }
  }

  Future<List<Movie>> fetchWatchlistMovies(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/watchlist'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> moviesJson = jsonDecode(response.body);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch watchlist movies');
    }
  }
}
