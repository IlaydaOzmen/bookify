class Book {
  int? id;
  String title;
  String author;
  String category;
  int publishYear;
  int pageCount;
  String description;
  bool isRead;
  bool isFavorite;
  String? notes;
  int readingProgress;
  DateTime addedDate;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.publishYear,
    required this.pageCount,
    required this.description,
    this.isRead = false,
    this.isFavorite = false,
    this.notes,
    this.readingProgress = 0,
    DateTime? addedDate,
  }) : addedDate = addedDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'publishYear': publishYear,
      'pageCount': pageCount,
      'description': description,
      'isRead': isRead ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'notes': notes,
      'readingProgress': readingProgress,
      'addedDate': addedDate.millisecondsSinceEpoch,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      publishYear: map['publishYear']?.toInt() ?? 0,
      pageCount: map['pageCount']?.toInt() ?? 0,
      description: map['description'] ?? '',
      isRead: (map['isRead'] ?? 0) == 1,
      isFavorite: (map['isFavorite'] ?? 0) == 1,
      notes: map['notes'],
      readingProgress: map['readingProgress']?.toInt() ?? 0,
      addedDate: DateTime.fromMillisecondsSinceEpoch(map['addedDate'] ?? 0),
    );
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? category,
    int? publishYear,
    int? pageCount,
    String? description,
    bool? isRead,
    bool? isFavorite,
    String? notes,
    int? readingProgress,
    DateTime? addedDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      publishYear: publishYear ?? this.publishYear,
      pageCount: pageCount ?? this.pageCount,
      description: description ?? this.description,
      isRead: isRead ?? this.isRead,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
      readingProgress: readingProgress ?? this.readingProgress,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
