import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/features/admin/data/admin_repository.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminRepository _adminRepo = AdminRepository();

  List<EventModel> _pendingEvents = [];
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final events = await _adminRepo.getPendingEvents();
      final users = await _adminRepo.getUsers();
      if (mounted) {
        setState(() {
          _pendingEvents = events;
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _moderateEvent(String id, String status) async {
    try {
      await _adminRepo.moderateEvent(id, status);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Мероприятие обновлено'), backgroundColor: AppColors.success));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Панель Администратора'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Модерация (События)'), Tab(text: 'Пользователи')],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _pendingEvents.isEmpty
                    ? const Center(child: Text('Нет мероприятий на модерацию'))
                    : ListView.builder(
                        itemCount: _pendingEvents.length,
                        itemBuilder: (context, index) {
                          final event = _pendingEvents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                            child: ListTile(
                              title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(event.city),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                                    onPressed: () => _moderateEvent(event.id, 'APPROVED'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel_rounded, color: AppColors.error),
                                    onPressed: () => _moderateEvent(event.id, 'REJECTED'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                _users.isEmpty
                    ? const Center(child: Text('Нет пользователей'))
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.avatarUrl.isNotEmpty 
                                  ? CachedNetworkImageProvider(user.avatarUrl)
                                  : null,
                              child: user.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                            ),
                            title: Text(user.name),
                            subtitle: Text('${user.email} • ${user.role}'),
                            trailing: user.role != 'ADMIN'
                                ? TextButton(
                                    onPressed: () async {
                                      await _adminRepo.makeAdmin(user.id);
                                      _loadData();
                                    },
                                    child: const Text('Сделать Admin'),
                                  )
                                : const SizedBox.shrink(),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
