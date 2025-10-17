class Book {
  final String id;
  final String title;
  final String authors;
  final String thumbnail;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['volumeInfo']['title'] ?? 'Sin título',
      authors: (json['volumeInfo']['authors'] != null)
          ? (json['volumeInfo']['authors'] as List).join(", ")
          : 'Desconocido',
      thumbnail: (json['volumeInfo']['imageLinks'] != null)
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : 'https://via.placeholder.com/128x200.png?text=No+Image',
    );
  }
}
