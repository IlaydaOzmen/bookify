import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import 'book_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final BookController bookController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favori Kitaplarım')),
      body: Obx(() {
        final favoriteBooks = bookController.favoriteBooks;

        if (favoriteBooks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Henüz favori kitap yok',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Kitapları favorilere ekleyerek burada görüntüleyebilirsiniz',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: favoriteBooks.length,
          itemBuilder: (context, index) {
            final book = favoriteBooks[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
                title: Text(
                  book.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Yazar: ${book.author}'),
                trailing: Icon(
                  book.isRead ? Icons.check_circle : Icons.schedule,
                  color: book.isRead ? Colors.green : Colors.orange,
                ),
                onTap: () => Get.to(() => BookDetailScreen(book: book)),
              ),
            );
          },
        );
      }),
    );
  }
}
