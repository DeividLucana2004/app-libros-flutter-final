import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(book.thumbnail, height: 200),
            ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(book.authors,
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(book.rating.toString()),
              ],
            ),
            const SizedBox(height: 12),
            Text(book.description),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => launchUrl(Uri.parse(book.previewLink)),
              icon: const Icon(Icons.open_in_new),
              label: const Text("Ver en Google Books"),
            ),
          ],
        ),
      ),
    );
  }
}
