import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/book.dart';
import '../services/database_service.dart';

enum SortType { nameAZ, nameZA, pageCount, dateAdded }

class BookController extends GetxController {
  final RxList<Book> books = <Book>[].obs;
  final RxList<Book> filteredBooks = <Book>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Tümü'.obs;
  final Rx<SortType> sortType = SortType.dateAdded.obs;
  final RxBool isDarkMode = false.obs;

  final List<String> categories = [
    'Tümü',
    'Roman',
    'Gerilim',
    'Macera',
    'Bilim Kurgu',
    'Fantastik',
    'Korku',
    'Polisiye',
    'Biyografi',
    'Tarih',
    'Bilim',
    'Kişisel Gelişim',
    'Felsefe',
    'Sanat',
    'Diğer',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      isLoading.value = true;
      final bookList = await DatabaseService.getAllBooks();
      books.assignAll(bookList);
      applyFilters();
    } catch (e) {
      Get.snackbar('Hata', 'Kitaplar yüklenirken hata oluştu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBook(Book book) async {
    try {
      final id = await DatabaseService.insertBook(book);
      book.id = id;
      books.add(book);
      applyFilters();
      Get.back();
      Get.snackbar('Başarılı', 'Kitap eklendi!');
    } catch (e) {
      Get.snackbar('Hata', 'Kitap eklenirken hata oluştu: $e');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await DatabaseService.updateBook(book);
      final index = books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        books[index] = book;
        applyFilters();
      }
      Get.back();
      Get.snackbar('Başarılı', 'Kitap güncellendi!');
    } catch (e) {
      Get.snackbar('Hata', 'Kitap güncellenirken hata oluştu: $e');
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await DatabaseService.deleteBook(id);
      books.removeWhere((book) => book.id == id);
      applyFilters();
      Get.snackbar('Başarılı', 'Kitap silindi!');
    } catch (e) {
      Get.snackbar('Hata', 'Kitap silinirken hata oluştu: $e');
    }
  }

  void toggleReadStatus(Book book) async {
    book.isRead = !book.isRead;
    if (book.isRead) {
      book.readingProgress = 100;
    }
    await updateBook(book);
  }

  void toggleFavorite(Book book) async {
    book.isFavorite = !book.isFavorite;
    await updateBook(book);
  }

  void updateReadingProgress(Book book, int progress) async {
    book.readingProgress = progress;
    if (progress == 100) {
      book.isRead = true;
    } else {
      book.isRead = false;
    }
    await updateBook(book);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setSortType(SortType type) {
    sortType.value = type;
    applyFilters();
  }

  void applyFilters() {
    var filtered = books.toList();

    // Kategori filtresi
    if (selectedCategory.value != 'Tümü') {
      filtered = filtered
          .where((book) => book.category == selectedCategory.value)
          .toList();
    }

    // Arama filtresi
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (book) =>
                book.title.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                book.author.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
          )
          .toList();
    }

    // Sıralama
    switch (sortType.value) {
      case SortType.nameAZ:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.nameZA:
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortType.pageCount:
        filtered.sort((a, b) => b.pageCount.compareTo(a.pageCount));
        break;
      case SortType.dateAdded:
        filtered.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
    }

    filteredBooks.assignAll(filtered);
  }

  List<Book> get favoriteBooks =>
      books.where((book) => book.isFavorite).toList();
  List<Book> get readBooks => books.where((book) => book.isRead).toList();
  List<Book> get unreadBooks => books.where((book) => !book.isRead).toList();

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
