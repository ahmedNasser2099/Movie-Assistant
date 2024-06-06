import 'package:flutter/material.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';
import 'package:movie_assistant/widgets/movie_item.dart';

class SeeAllScreen extends StatefulWidget {
  final String category;
  final String userId;

  const SeeAllScreen({super.key, required this.category, required this.userId});

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = BackendService(Constants.baseUrl).fetchMoviesByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies available'));
          } else {
            final movies = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieItem(movie: movies[index]);
              },
            );
          }
        },
      ),
    );
  }
}
