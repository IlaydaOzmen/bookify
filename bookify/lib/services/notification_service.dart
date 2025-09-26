import 'dart:async';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';

class NotificationService {
  static Timer? _timer;

  static void startPeriodicCheck() {
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      _checkUnreadBooks();
    });
  }

  static void stopPeriodicCheck() {
    _timer?.cancel();
    _timer = null;
  }

  static void _checkUnreadBooks() {
    final BookController bookController = Get.find();
    final unreadBooks = bookController.unreadBooks;

    final booksNotReadFor7Days = unreadBooks.where((book) {
      final daysSinceAdded = DateTime.now().difference(book.addedDate).inDays;
      return daysSinceAdded >= 7;
    }).toList();

    if (booksNotReadFor7Days.isNotEmpty) {
      Get.snackbar(
        'Kitap Hatırlatması',
        '${booksNotReadFor7Days.length} kitabınız uzun süredir okunmayı bekliyor!',
        duration: Duration(seconds: 5),
      );
    }
  }
}
