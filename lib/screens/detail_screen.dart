import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_show_provider.dart';

class DetailScreen extends StatefulWidget {
  final int showId;

  const DetailScreen({Key? key, required this.showId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TvShowProvider>(context, listen: false).loadShowDetails(widget.showId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Consumer<TvShowProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (provider.error.isNotEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text('Erreur')),
              body: Center(
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
                      onPressed: () => provider.loadShowDetails(widget.showId),
                      icon: Icon(Icons.refresh),
                      label: Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final show = provider.selectedShow;
          if (show == null) {
            return Scaffold(
              appBar: AppBar(title: Text('Série non trouvée')),
              body: Center(child: Text('Aucune information disponible')),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'show_${show.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          show.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surface,
                              child: Icon(Icons.error, color: theme.colorScheme.error),
                            );
                          },
                        ),
                        // Gradient pour améliorer la lisibilité
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                        // Titre de la série positionné en bas
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            show.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Contenu principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(theme, 'Informations'),
                              SizedBox(height: 12),
                              _buildInfoGrid(theme, show),
                            ],
                          ),
                        ),
                      ),
                      
                      // Genres
                      if (show.genres != null && show.genres!.isNotEmpty)
                        Card(
                          margin: EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(theme, 'Genres'),
                                SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: show.genres!.map((genre) => Chip(
                                    backgroundColor: theme.colorScheme.secondaryContainer,
                                    side: BorderSide.none,
                                    label: Text(
                                      genre,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // Description
                      if (show.description != null && show.description!.isNotEmpty)
                        Card(
                          margin: EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(theme, 'Description'),
                                SizedBox(height: 12),
                                Text(
                                  show.description!,
                                  style: theme.textTheme.bodyLarge,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(ThemeData theme, dynamic show) {
    return Column(
      children: [
        _buildInfoRow(theme, 'Réseau', show.network, Icons.tv),
        _buildInfoRow(theme, 'Statut', show.status, Icons.info_outline),
        _buildInfoRow(theme, 'Pays', show.country, Icons.public),
        _buildInfoRow(theme, 'Date de début', show.startDate, Icons.calendar_today),
        _buildInfoRow(theme, 'Date de fin', show.endDate, Icons.event_busy),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String? value, IconData icon) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.secondary,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 