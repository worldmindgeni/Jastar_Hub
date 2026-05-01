import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/shared/widgets/app_button.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchCurrentProfile();
  }

  Future<void> _fetchCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.client.get('/users/profile');
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            _nameController.text = res.data['name'] ?? '';
            _bioController.text = res.data['bio'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_selectedImage != null) {
        String fileName = _selectedImage!.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(_selectedImage!.path, filename: fileName),
        });
        await ApiClient.client.post('/users/avatar', data: formData);
      }

      await ApiClient.client.patch('/users/profile', data: {
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('profile_updated'))),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка обновления профиля')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.tr('edit_profile')),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading && _nameController.text.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight,
                          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                          child: _selectedImage == null
                              ? Icon(Icons.camera_alt, size: 40, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.tr('name'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => v != null && v.isEmpty ? 'Введите имя' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: context.tr('bio'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: context.tr('save'),
                      onPressed: _saveProfile,
                      isLoading: _isLoading,
                      variant: AppButtonVariant.gradient,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
