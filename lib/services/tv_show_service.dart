import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_show.dart';

class TvShowService {
  static const String _baseUrl = 'https://www.episodate.com/api';

  Future<List<TvShow>> getPopularShows(int page) async {
    final response = await http.get(Uri.parse('$_baseUrl/most-popular?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tvShows = data['tv_shows'] as List;
      return tvShows.map((show) => TvShow.fromJson(show)).toList();
    } else {
      throw Exception('Échec du chargement des séries populaires');
    }
  }

  Future<List<TvShow>> searchShows(String query, int page) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tvShows = data['tv_shows'] as List;
      return tvShows.map((show) => TvShow.fromJson(show)).toList();
    } else {
      throw Exception('Échec de la recherche de séries');
    }
  }

  Future<TvShow> getShowDetails(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/show-details?q=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tvShowData = data['tvShow'];
      return TvShow.fromJson(tvShowData);
    } else {
      throw Exception('Échec du chargement des détails de la série');
    }
  }
} 