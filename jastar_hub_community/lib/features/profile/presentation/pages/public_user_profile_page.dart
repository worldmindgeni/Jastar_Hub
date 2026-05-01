import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/shared/widgets/app_button.dart';

class PublicUserProfilePage extends StatefulWidget {
  final String userId;

  const PublicUserProfilePage({super.key, required this.userId});

  @override
  State<PublicUserProfilePage> createState() => _PublicUserProfilePageState();
}

class _PublicUserProfilePageState extends State<PublicUserProfilePage> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final res = await ApiClient.client.get('/users/${widget.userId}');
      if (res.statusCode == 200 && mounted) {
        setState(() {
          _user = res.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Err fetching user: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('Пользователь не найден')),
      );
    }

    final avatarUrl = _user!['avatarUrl'] ?? '';
    final name = _user!['name'] ?? 'Unknown User';
    final bio = _user!['bio'] ?? '';
    final rank = _user!['rank'] ?? 'Newcomer';
    final points = _user!['points'] ?? 0;
    final followers = _user!['followers'] ?? 0;
    final following = _user!['following'] ?? 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                  image: DecorationImage(
                    image: avatarUrl.isNotEmpty 
                        ? CachedNetworkImageProvider(avatarUrl) 
                        // fallback image
                        : const CachedNetworkImageProvider('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rank,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(points.toString(), 'Очки', isDark),
                  _buildStatCard(followers.toString(), 'Followers', isDark),
                  _buildStatCard(following.toString(), 'Following', isDark),
                ],
              ),
              const SizedBox(height: 24),
              if (bio.isNotEmpty)
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 48),
              
              // Написать (Message) button
              AppButton(
                text: 'Написать',
                variant: AppButtonVariant.gradient,
                onPressed: () {
                  context.push(
                    '/chat/${widget.userId}', 
                    extra: {
                      'partnerName': name,
                      'partnerAvatarUrl': avatarUrl,
                    }
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
      ],
    );
  }
}
