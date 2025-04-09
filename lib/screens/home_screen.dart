import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_show_provider.dart';
import '../models/tv_show.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TvShowProvider>(context, listen: false).loadPopularShows();
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<TvShowProvider>(context, listen: false);
      if (!provider.isLoading && !_isSearching) {
        provider.loadPopularShows();
      }
    }
  }

  void _onShowTap(BuildContext context, TvShow show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(showId: show.id),
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _searchController.clear();
        Provider.of<TvShowProvider>(context, listen: false).clearSearch();
        _animationController.reverse().then((_) {
          setState(() {
            _isSearching = false;
          });
        });
      } else {
        _isSearching = true;
        _animationController.forward();
      }
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<TvShowProvider>(context, listen: false).searchShows(query);
    }
  }

  void _retourAccueil() {
    setState(() {
      _searchController.clear();
      Provider.of<TvShowProvider>(context, listen: false).clearSearch();
      _animationController.reverse().then((_) {
        setState(() {
          _isSearching = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une série...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                autofocus: true,
                onSubmitted: _performSearch,
              )
            : Text(
                'Séries TV Populaires',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Consumer<TvShowProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.popularShows.isEmpty && provider.searchResults.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (provider.error.isNotEmpty && provider.popularShows.isEmpty && provider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Erreur: ${provider.error}',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadPopularShows(refresh: true),
                    icon: Icon(Icons.refresh),
                    label: Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final shows = _isSearching ? provider.searchResults : provider.popularShows;

          if (shows.isEmpty && _isSearching && provider.searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: theme.colorScheme.secondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune série trouvée pour\n"${provider.searchQuery}"',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _retourAccueil,
                    icon: Icon(Icons.home),
                    label: Text('Retour à l\'accueil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => provider.loadPopularShows(refresh: true),
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: shows.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == shows.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      }

                      final show = shows[index];
                      return Hero(
                        tag: 'show_${show.id}',
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () => _onShowTap(context, show),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image de la série avec effet d'ombre
                                Container(
                                  width: 120,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      show.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: theme.colorScheme.surfaceVariant,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: theme.colorScheme.onSurfaceVariant,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Informations de la série
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          show.name,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        if (show.network != null)
                                          _buildInfoItem(
                                            theme, Icons.tv, 'Réseau: ${show.network}',
                                          ),
                                        if (show.status != null)
                                          _buildInfoItem(
                                            theme, Icons.info_outline, 'Statut: ${show.status}',
                                          ),
                                        SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            child: Text(
                                              'Voir détails',
                                              style: TextStyle(
                                                color: theme.colorScheme.onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_isSearching && shows.isNotEmpty)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _retourAccueil,
                      icon: Icon(Icons.home),
                      label: Text('Retour à l\'accueil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 6,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 