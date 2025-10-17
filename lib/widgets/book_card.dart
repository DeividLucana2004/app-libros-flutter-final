import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onAdd;

  const BookCard({super.key, required this.book, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
          );
        },
        leading: Image.network(book.thumbnail, width: 50, fit: BoxFit.cover),
        title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(book.authors),
        trailing: IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
