import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../widgets/custom_button.dart';

/// Halaman 4: Tambah / Edit Catatan dengan validasi input komprehensif
class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({
    super.key,
    this.note,
  });

  bool get isEditing => note != null;

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  late String _selectedCategory;
  late int _selectedColorValue;
  late bool _isFavorite;
  bool _isSaving = false;

  final List<String> _formCategories = [
    'Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Ide',
    'Tugas',
  ];

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _selectedCategory = note?.category ?? 'Kuliah';
    _selectedColorValue = note?.colorValue ?? 0xFFFFFFFF;
    _isFavorite = note?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // 1. Validasi Input Form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.isEditing) {
      // Update Catatan
      noteProvider.updateNote(
        id: widget.note!.id,
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        colorValue: _selectedColorValue,
        isFavorite: _isFavorite,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Perubahan catatan berhasil disimpan!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Tambah Catatan Baru
      noteProvider.addNote(
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        colorValue: _selectedColorValue,
        isFavorite: _isFavorite,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Catatan baru berhasil ditambahkan!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.isEditing ? 'Edit Catatan' : 'Tambah Catatan Baru'),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Judul Catatan
                Text(
                  'Judul Catatan *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Cth: Catatan Praktikum Pemrograman Bergerak',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul catatan wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Judul minimal 3 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Pemilihan Kategori
                Text(
                  'Kategori Catatan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _formCategories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    final catColor = AppColors.categoryColors[cat];

                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: catColor?.accent ?? AppColors.primary,
                      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? (catColor?.accent ?? AppColors.primary)
                            : (isDark ? AppColors.darkBorder : AppColors.border),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Pilihan Warna Kartu Catatan
                Text(
                  'Warna Aksen Kartu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppColors.noteColorOptions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final option = AppColors.noteColorOptions[index];
                      final isSelected = _selectedColorValue == option.color.toARGB32();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorValue = option.color.toARGB32();
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: option.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkBorder : AppColors.border),
                              width: isSelected ? 2.5 : 1.2,
                            ),
                          ),
                          child: isSelected
                              ? const Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Switch Tandai Favorit
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: _isFavorite ? AppColors.favorite : AppColors.textMuted,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tandai sebagai Favorit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Akses cepat dari filter dashboard',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: _isFavorite,
                        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.favorite;
                          }
                          return Colors.grey.shade400;
                        }),
                        onChanged: (val) {
                          setState(() {
                            _isFavorite = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Input Isi Catatan
                Text(
                  'Isi Catatan *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  minLines: 8,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan catatan, rangkuman materi, atau to-do list Anda di sini...',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Isi catatan wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Tombol Simpan Bawah
                CustomButton(
                  text: widget.isEditing ? 'Perbarui Catatan' : 'Simpan Catatan',
                  icon: Icons.save_rounded,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
