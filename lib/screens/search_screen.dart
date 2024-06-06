import 'package:flutter/material.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/services/backend_service.dart';
import 'package:movie_assistant/widgets/movie_card.dart';
import '../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Movie> movies = await BackendService(Constants.baseUrl).searchMovies(query);
      setState(() {
        _searchResults = movies;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
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
        title: const Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMovies(_searchController.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: _searchResults[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
