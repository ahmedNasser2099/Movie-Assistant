// lib/models/movie_model.dart

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String releaseYear;
  final double rating;
  final String story;
  final List<String> cast;
  final String trailerUrl;
  final String productionCompany;
  final String genre;
  final String language;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.rating,
    required this.story,
    required this.cast,
    required this.trailerUrl,
    required this.productionCompany,
    required this.genre,
    required this.language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterUrl: json['posterUrl'],
      releaseYear: json['releaseYear'],
      rating: json['rating'].toDouble(),
      story: json['story'],
      cast: List<String>.from(json['cast']),
      trailerUrl: json['trailerUrl'],
      productionCompany: json['productionCompany'],
      genre: json['genre'],
      language: json['language'],
    );
  }
}
