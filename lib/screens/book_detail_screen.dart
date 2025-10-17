import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // 👈 Nuevo: para abrir enlaces externos
import '../models/book.dart';
import '../providers/reading_list_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  String description = '';
  String rating = '';
  String previewLink = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    final url =
        'https://www.googleapis.com/books/v1/volumes/${widget.book.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final info = data['volumeInfo'];
      setState(() {
        description = info['description'] ?? 'Sin descripción disponible.';
        rating = info['averageRating']?.toString() ?? 'Sin calificación';
        previewLink = info['previewLink'] ?? '';
        loading = false;
      });
    } else {
      setState(() {
        description = 'No se pudieron obtener los detalles del libro.';
        rating = 'N/A';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReadingListProvider>(context);
    final isInList = provider.readingList.any((b) => b.id == widget.book.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(widget.book.thumbnail,
                        height: 220, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Autor(es): ${widget.book.authors}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "⭐ Calificación: $rating",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Descripción:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isInList) {
                          provider.removeBook(widget.book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Libro eliminado de tu lista')),
                          );
                        } else {
                          provider.addBook(widget.book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Libro añadido a tu lista')),
                          );
                        }
                        setState(() {}); // refresca el botón
                      },
                      icon: Icon(isInList ? Icons.delete : Icons.add),
                      label: Text(isInList
                          ? "Eliminar de la lista"
                          : "Agregar a la lista"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (previewLink.isNotEmpty)
                    Center(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text("Ver en Google Books"),
                        onPressed: () async {
                          final uri = Uri.parse(previewLink);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('No se pudo abrir el enlace.')),
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
