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

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _readingList.map((b) => b.toJson()).toList();
    prefs.setString('readingList', json.encode(data));
  }

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
