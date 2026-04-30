import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final EventRepository _eventRepository = EventRepository();

  String _title = '';
  String _description = '';
  String _category = 'Technology';
  String _city = 'Almaty';
  String _location = '';
  String _imageUrl = 'https://picsum.photos/seed/event/600/400';
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  double _price = 0;
  int _maxAttendees = 50;
  bool _isLoading = false;

  final List<String> _categories = [
    'Technology', 'Sports', 'Music', 'Art', 'Food', 'Education', 'Business', 'Culture', 'Wellness', 'Entertainment'
  ];

  final List<String> _cities = [
    'Almaty', 'Astana', 'Shymkent', 'Karaganda', 'Aktobe', 'Atyrau', 'Pavlodar'
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await _eventRepository.createEvent({
        'title': _title,
        'description': _description,
        'category': _category.toLowerCase(),
        'city': _city,
        'location': _location,
        'date': _date.toIso8601String(),
        'latitude': 43.2389, // Default to Almaty coordinates if simple
        'longitude': 76.8897,
        'price': _price,
        'maxAttendees': _maxAttendees,
        'imageUrl': _imageUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Мероприятие отправлено на модерацию!'), backgroundColor: AppColors.success),
        );
        context.pop(); // Go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Создать Мероприятие'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Введите название' : null,
                onSaved: (val) => _title = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Введите описание' : null,
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _city,
                decoration: InputDecoration(
                  labelText: 'Город',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _city = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Локация (Точный адрес)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Введите адрес' : null,
                onSaved: (val) => _location = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(
                  labelText: 'URL Обложки (Изображение)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (val) => _imageUrl = val ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Цена',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSaved: (val) => _price = double.tryParse(val ?? '0') ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: '50',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Мест (Max)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSaved: (val) => _maxAttendees = int.tryParse(val ?? '50') ?? 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Создать', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
