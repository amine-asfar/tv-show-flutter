import 'package:flutter/material.dart';
import '../models/tv_show.dart';
import '../services/tv_show_service.dart';

class TvShowProvider extends ChangeNotifier {
  final TvShowService _tvShowService = TvShowService();
  
  List<TvShow> _popularShows = [];
  List<TvShow> _searchResults = [];
  TvShow? _selectedShow;
  
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  String _searchQuery = '';

  // Getters
  List<TvShow> get popularShows => _popularShows;
  List<TvShow> get searchResults => _searchResults;
  TvShow? get selectedShow => _selectedShow;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  // Méthodes
  Future<void> loadPopularShows({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _popularShows = [];
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final shows = await _tvShowService.getPopularShows(_currentPage);
      _popularShows.addAll(shows);
      _currentPage++;
    } catch (e) {
      _error = 'Impossible de charger les séries: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchShows(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    _searchQuery = query;
    notifyListeners();

    try {
      final results = await _tvShowService.searchShows(query, 1);
      _searchResults = results;
    } catch (e) {
      _error = 'Échec de la recherche: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShowDetails(int id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final show = await _tvShowService.getShowDetails(id);
      _selectedShow = show;
    } catch (e) {
      _error = 'Impossible de charger les détails: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }
} 