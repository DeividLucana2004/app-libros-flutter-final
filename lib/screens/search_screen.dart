import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/reading_list_provider.dart';
import '../widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Book> _results = [];
  bool _loading = false;

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;
    setState(() => _loading = true);

    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      setState(() {
        _results = items.map((item) => Book.fromJson(item)).toList();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      throw Exception('Error al buscar libros');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReadingListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Libros")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Escribe el nombre del libro",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchBooks(_controller.text),
                ),
              ),
              onSubmitted: _searchBooks,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final book = _results[index];
                      return BookCard(
                        book: book,
                        onAdd: () => provider.addBook(book),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
