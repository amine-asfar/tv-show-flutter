class TvShow {
  final int id;
  final String name;
  final String imageUrl;
  final String permalink;
  String? description;
  String? country;
  String? status;
  String? network;
  List<String>? genres;
  String? startDate;
  String? endDate;

  TvShow({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.permalink,
    this.description,
    this.country,
    this.status,
    this.network,
    this.genres,
    this.startDate,
    this.endDate,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_thumbnail_path'] ?? '',
      permalink: json['permalink'] ?? '',
      description: json['description'],
      country: json['country'],
      status: json['status'],
      network: json['network'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
} 