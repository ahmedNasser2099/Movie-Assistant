
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_assistant/constants.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/screens/movie_details_screen.dart';
import 'package:movie_assistant/services/backend_service.dart';

class MovieCarousel extends StatefulWidget {
final String userId; 

  const MovieCarousel({super.key, required this.userId});

  @override
  _MovieCarouselState createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = BackendService(Constants.baseUrl).fetchRecommendedMovies(Constants.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recommendations available'));
        } else {
          final movies = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 400,
              aspectRatio: 16/9,
              autoPlay: true,            
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
            items: movies.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(movie.posterUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to movie details screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movieId: movie.id),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Rating: ${movie.rating}/10',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

