class Book {
  final String id;
  final String title;
  final String authors;
  final String description;
  final String thumbnail;
  final double rating;
  final String previewLink;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.rating,
    required this.previewLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volume = json['volumeInfo'] ?? {};
    return Book(
      id: json['id'] ?? '',
      title: volume['title'] ?? 'Sin título',
      authors: (volume['authors'] != null)
          ? (volume['authors'] as List).join(', ')
          : 'Autor desconocido',
      description: volume['description'] ?? 'Sin descripción disponible.',
      thumbnail: volume['imageLinks'] != null
          ? volume['imageLinks']['thumbnail']
          : 'https://via.placeholder.com/128x200.png?text=Sin+Imagen',
      rating: (volume['averageRating'] != null)
          ? (volume['averageRating'] as num).toDouble()
          : 0.0,
      previewLink: volume['previewLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnail': thumbnail,
        'rating': rating,
        'previewLink': previewLink,
      };
}
