import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  final Future<List<Movie>> Function() fetchMovies;

  const CategoryScreen({super.key, required this.category, required this.fetchMovies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Movie> movies = snapshot.data as List<Movie>;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: movies[index]);
              },
            );
          }
        },
      ),
    );
  }
}
