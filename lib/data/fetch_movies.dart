import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchMovies {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiN2UxNmRmMGIxNWMyZmZhMjQyNmZjZDRjYTUwNTIwOCIsIm5iZiI6MTczNjE0Mjk5Mi42Miwic3ViIjoiNjc3YjcwOTBjZjRkNTljODRmNzI0MjA5Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.-ZP5432xq1tOT1b6012BjlLxp5yEI9MM3KfmlEEYWrY'; // Insert your TMDB v4 token

  //fetch trending movies and tv for the day
  Future<List<dynamic>> fetchTrending() async {
    final url = Uri.parse('$_baseUrl/trending/all/day?language=en-US');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['results'] ?? [];
    } else {
      throw Exception('Failed to fetch trending. Code: ${response.statusCode}');
    }
  }

  //fetch detail for a Movie
  Future<Map<String, dynamic>> fetchMovieDetail(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId?language=en-US');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  //fetch detail for a TV show
  Future<Map<String, dynamic>> fetchTvDetail(int tvId) async {

    final url = Uri.parse('$_baseUrl/tv/$tvId?language=en-US');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('${response.statusCode}');
    }
  }
}
