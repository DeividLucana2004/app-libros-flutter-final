import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _currentQuery = "";
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadTrendingBooks();
    _loadRecentSearches();
  }

  // 🔹 Carga las tendencias al inicio
  Future<void> _loadTrendingBooks() async {
    setState(() {
      _loading = true;
      _currentQuery = "Tendencias globales";
    });

    final url =
        'https://www.googleapis.com/books/v1/volumes?q=bestsellers&maxResults=15';
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
    }
  }

  // 🔹 Cargar historial de búsqueda guardado
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  // 🔹 Guardar término de búsqueda
  Future<void> _saveSearch(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.remove(query); // evita duplicados
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
    });
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  // 🔹 Buscar libros según texto
  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;
    await _saveSearch(query);
    setState(() {
      _loading = true;
      _currentQuery = query;
    });

    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&maxResults=15';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReadingListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Libros"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrendingBooks,
            tooltip: "Ver tendencias",
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Buscar libros por nombre",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchBooks(_controller.text),
                ),
              ),
              onSubmitted: _searchBooks,
            ),
          ),
          // 🔹 Chips del historial
          if (_recentSearches.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: _recentSearches.map((term) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(term),
                      onPressed: () => _searchBooks(term),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              _currentQuery.isEmpty
                  ? "Resultados"
                  : "Mostrando: $_currentQuery",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
