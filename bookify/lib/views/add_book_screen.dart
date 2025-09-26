import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../models/book.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;

  AddBookScreen({this.book});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final BookController bookController = Get.find();

  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController publishYearController;
  late TextEditingController pageCountController;
  late TextEditingController descriptionController;
  late TextEditingController notesController;

  String selectedCategory = 'Roman';
  bool isRead = false;
  bool isFavorite = false;
  int readingProgress = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initControllers();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _initControllers() {
    if (widget.book != null) {
      titleController = TextEditingController(text: widget.book!.title);
      authorController = TextEditingController(text: widget.book!.author);
      publishYearController = TextEditingController(
        text: widget.book!.publishYear.toString(),
      );
      pageCountController = TextEditingController(
        text: widget.book!.pageCount.toString(),
      );
      descriptionController = TextEditingController(
        text: widget.book!.description,
      );
      notesController = TextEditingController(text: widget.book!.notes ?? '');
      selectedCategory = widget.book!.category;
      isRead = widget.book!.isRead;
      isFavorite = widget.book!.isFavorite;
      readingProgress = widget.book!.readingProgress;
    } else {
      titleController = TextEditingController();
      authorController = TextEditingController();
      publishYearController = TextEditingController();
      pageCountController = TextEditingController();
      descriptionController = TextEditingController();
      notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    titleController.dispose();
    authorController.dispose();
    publishYearController.dispose();
    pageCountController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildBasicInfoCard(),
                        const SizedBox(height: 20),
                        _buildDetailsCard(),
                        const SizedBox(height: 20),
                        _buildStatusCard(),
                        const SizedBox(height: 32),
                        _buildSaveButton(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final isEditing = widget.book != null;
    final categoryColor = _getCategoryColor(selectedCategory);

    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: categoryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          isEditing ? 'Kitap Düzenle' : 'Yeni Kitap Ekle',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor,
                categoryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Icon(
                  isEditing ? Icons.edit_note : Icons.add_circle_outline,
                  color: Colors.white.withOpacity(0.3),
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.book, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Temel Bilgiler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: titleController,
            label: 'Kitap Adı',
            icon: Icons.book_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kitap adı gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: authorController,
            label: 'Yazar',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Yazar adı gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info_outline,
                    color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Detay Bilgiler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: publishYearController,
                  label: 'Yayın Yılı',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Yayın yılı gerekli';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: pageCountController,
                  label: 'Sayfa Sayısı',
                  icon: Icons.pages,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sayfa sayısı gerekli';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: descriptionController,
            label: 'Açıklama',
            icon: Icons.description,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Açıklama gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: notesController,
            label: 'Notlar (İsteğe bağlı)',
            icon: Icons.note,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(selectedCategory).withOpacity(0.05),
            _getCategoryColor(selectedCategory).withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getCategoryColor(selectedCategory).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.settings, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Durum ve Ayarlar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusSwitch(
            title: 'Okundu',
            subtitle: 'Kitabı okudunuz mu?',
            value: isRead,
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onChanged: (value) {
              setState(() {
                isRead = value;
                if (value) {
                  readingProgress = 100;
                }
              });
            },
          ),
          const SizedBox(height: 12),
          _buildStatusSwitch(
            title: 'Favori',
            subtitle: 'Bu kitap favorilerinizde görünsün mü?',
            value: isFavorite,
            icon: Icons.favorite_outline,
            color: Colors.red,
            onChanged: (value) {
              setState(() {
                isFavorite = value;
              });
            },
          ),
          if (!isRead) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Okuma İlerlemesi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(selectedCategory)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '%$readingProgress',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(selectedCategory),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _getCategoryColor(selectedCategory),
                      thumbColor: _getCategoryColor(selectedCategory),
                      overlayColor:
                          _getCategoryColor(selectedCategory).withOpacity(0.2),
                      valueIndicatorColor: _getCategoryColor(selectedCategory),
                    ),
                    child: Slider(
                      value: readingProgress.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '%$readingProgress',
                      onChanged: (value) {
                        setState(() {
                          readingProgress = value.round();
                          if (readingProgress == 100) {
                            isRead = true;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(selectedCategory).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: _getCategoryColor(selectedCategory),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Kategori',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(selectedCategory).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.category,
              color: _getCategoryColor(selectedCategory),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: bookController.categories
            .where((cat) => cat != 'Tümü')
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(category),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
          });
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(selectedCategory),
            _getCategoryColor(selectedCategory).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(selectedCategory).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _saveBook,
        icon: Icon(
          widget.book != null ? Icons.update : Icons.save,
          color: Colors.white,
        ),
        label: Text(
          widget.book != null ? 'Güncelle' : 'Kaydet',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Roman':
        return Colors.purple;
      case 'Tarih':
        return Colors.brown;
      case 'Bilim':
        return Colors.blue;
      case 'Kişisel Gelişim':
        return Colors.green;
      case 'Felsefe':
        return Colors.indigo;
      case 'Sanat':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        id: widget.book?.id,
        title: titleController.text.trim(),
        author: authorController.text.trim(),
        category: selectedCategory,
        publishYear: int.parse(publishYearController.text),
        pageCount: int.parse(pageCountController.text),
        description: descriptionController.text.trim(),
        isRead: isRead,
        isFavorite: isFavorite,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        readingProgress: readingProgress,
        addedDate: widget.book?.addedDate,
      );

      if (widget.book != null) {
        bookController.updateBook(book);
      } else {
        bookController.addBook(book);
      }

      _animationController.reverse().then((_) {
        Get.back();
      });
    }
  }
}
