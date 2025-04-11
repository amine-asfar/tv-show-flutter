# Application TV Show - Amine ASFAR Oussama FATNASSI

## Introduction

Cette application Flutter permet aux utilisateurs de découvrir des séries télévisées populaires, rechercher une série spécifique et consulter ses détails. Elle consomme l'API Episodate pour récupérer les données et met en œuvre une architecture basée sur http, provider, et ChangeNotifier pour la gestion d'état.

## Architecture

L'application suit une architecture structurée en couches:

### 1. Modèle (Model Layer)

Le modèle `TvShow` représente les données des séries avec leurs attributs:
- ID, nom, image, description
- Informations supplémentaires: réseau, statut, pays, genre, dates

```dart
class TvShow {
  final int id;
  final String name;
  final String imageUrl;
  // Autres attributs...
}
```

### 2. Service API (Data Layer)

Le service `TvShowService` gère les requêtes HTTP vers l'API Episodate:
- `getPopularShows(int page)`: Récupère les séries populaires paginées
- `searchShows(String query, int page)`: Recherche des séries par nom
- `getShowDetails(int id)`: Obtient les détails d'une série spécifique

Endpoints utilisés:
- Most Popular: `https://www.episodate.com/api/most-popular?page=:page`
- Search: `https://www.episodate.com/api/search?q=:name&page=:page`
- Show Details: `https://www.episodate.com/api/show-details?q=:id`

### 3. Gestion d'état (State Management)

La gestion d'état utilise `ChangeNotifier` avec `Provider` pour stocker et manipuler les données:

```dart
class TvShowProvider extends ChangeNotifier {
  // État de l'application
  List<TvShow> _popularShows = [];
  List<TvShow> _searchResults = [];
  TvShow? _selectedShow;
  bool _isLoading = false;
  String _error = '';

  // Méthodes pour manipuler l'état
  Future<void> loadPopularShows({bool refresh = false}) { ... }
  Future<void> searchShows(String query) { ... }
  Future<void> loadShowDetails(int id) { ... }
}
```

Cette approche permet:
- Une séparation claire entre la logique et l'affichage
- Une mise à jour automatique de l'interface quand les données changent
- Une gestion efficace des états de chargement et d'erreur

### 4. Interface utilisateur (UI Layer)

L'interface est composée de deux écrans principaux:

1. **HomeScreen**:
   - Affiche les séries populaires avec pagination automatique
   - Intègre une barre de recherche dynamique
   - Gère les différents états (chargement, erreur, résultats vides)
   - Permet la navigation vers l'écran de détail

2. **DetailScreen**:
   - Affiche les informations complètes d'une série
   - Présente l'image, le titre, la description et autres informations
   - Utilise SliverAppBar pour une expérience visuelle améliorée

## Design et thème

L'application utilise Material Design 3 avec:
- Une palette de couleurs personnalisée (violet et turquoise)
- Support complet du mode clair/sombre
- Des animations et transitions fluides
- Des composants modernes (cards, sliver, hero animations)

## Fonctionnalités principales

1. **Découverte de séries populaires**:
   - Liste paginée avec chargement automatique lors du défilement
   - Pull-to-refresh pour actualiser la liste
   - Affichage des informations clés (titre, réseau, statut)

2. **Recherche de séries**:
   - Recherche en temps réel
   - Interface dédiée pour les résultats
   - Gestion des résultats vides

3. **Consultation des détails**:
   - Présentation détaillée avec image en couverture
   - Organisation des informations en sections
   - Affichage des genres et de la description complète

4. **Navigation et UX**:
   - Transitions animées entre les écrans
   - Feedback visuel lors des chargements
   - Gestion des erreurs avec options de réessai

## Comment exécuter l'application

1. Prérequis:
   - Flutter SDK (dernière version stable)
   - Un émulateur ou appareil physique

2. Installation:
   ```
   git clone [url-du-repo]
   cd tv_show
   flutter pub get
   ```

3. Exécution:
   ```
   flutter run
   ```

## Structure du projet

```
lib/
├── main.dart             # Point d'entrée de l'application
├── models/
│   └── tv_show.dart      # Modèle de données
├── providers/
│   └── tv_show_provider.dart  # Gestion d'état
├── screens/
│   ├── home_screen.dart  # Écran d'accueil
│   └── detail_screen.dart # Écran de détail
└── services/
    └── tv_show_service.dart  # Service API
```

## Dépendances principales

- `http`: Pour les requêtes API REST
- `provider`: Pour la gestion d'état
- `flutter/material.dart`: Pour l'interface utilisateur
