import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/book.dart';

class ReadingListProvider extends ChangeNotifier {
  final List<Book> _readingList = [];

  List<Book> get readingList => _readingList;

  ReadingListProvider() {
    _loadBooks();
  }

  void addBook(Book book) {
    if (!_readingList.any((b) => b.id == book.id)) {
      _readingList.add(book);
      _saveBooks();
      notifyListeners();
    }
  }

  void removeBook(Book book) {
    _readingList.removeWhere((b) => b.id == book.id);
    _saveBooks();
    notifyListeners();
  }

  // 🔹 Guarda la lista de libros localmente
  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _readingList
        .map((b) => {
              'id': b.id,
              'title': b.title,
              'authors': b.authors,
              'thumbnail': b.thumbnail,
            })
        .toList();
    prefs.setString('readingList', json.encode(data));
  }

  // 🔹 Carga la lista al iniciar la app
  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('readingList');
    if (jsonString != null) {
      final List<dynamic> data = json.decode(jsonString);
      _readingList.clear();
      _readingList.addAll(data.map((item) => Book.fromJson(item)).toList());
      notifyListeners();
    }
  }
}
