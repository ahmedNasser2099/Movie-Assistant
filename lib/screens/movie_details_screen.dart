// lib/screens/movie_details_screen.dart

import 'package:flutter/material.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Movie> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = BackendService(Constants.baseUrl).fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Movie>(
            future: futureMovie,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                final movie = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieHeader(imageUrl: movie.posterUrl),
                      MovieInfo(movie: movie),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class MovieHeader extends StatelessWidget {
  final String imageUrl;

  const MovieHeader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 20,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

class MovieInfo extends StatelessWidget {
  final Movie movie;

  const MovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 4),
              Text('${movie.rating}/10', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 16),
              const Icon(Icons.date_range, color: Colors.white),
              const SizedBox(width: 4),
              Text(movie.releaseYear, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 16),
              const Icon(Icons.language, color: Colors.white),
              const SizedBox(width: 4),
              Text(movie.language, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to trailer or play it
            },
            child: const Text('Watch Trailer'),
          ),
          const SizedBox(height: 16),
          Text(
            'Genres: ${movie.genre}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            movie.story,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Production Company: ${movie.productionCompany}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cast:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          CastList(cast: movie.cast),
        ],
      ),
    );
  }
}

class CastList extends StatelessWidget {
  final List<String> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cast.map((actor) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/actor_image.jpg'), // replace with actual image URL
          ),
          title: Text(
            actor,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
