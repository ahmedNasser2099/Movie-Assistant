import 'package:flutter/material.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/screens/movie_details_screen.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;

  const MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movie.id),
          ),
        );
      },
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(movie.title, textAlign: TextAlign.center),
        ),
        child: Image.network(
          movie.posterUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
