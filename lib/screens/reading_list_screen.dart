import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reading_list_provider.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, dynamic book) async {
    final provider = Provider.of<ReadingListProvider>(context, listen: false);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Deseas eliminar \"${book.title}\" de tu lista?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      provider.removeBook(book);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eliminaste "${book.title}"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReadingListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Lista de Lectura")),
      body: provider.readingList.isEmpty
          ? const Center(child: Text("Aún no tienes libros guardados"))
          : ListView.builder(
              itemCount: provider.readingList.length,
              itemBuilder: (context, index) {
                final book = provider.readingList[index];
                return ListTile(
                  leading: Image.network(book.thumbnail, width: 50),
                  title: Text(book.title),
                  subtitle: Text(book.authors),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, book),
                  ),
                );
              },
            ),
    );
  }
}
