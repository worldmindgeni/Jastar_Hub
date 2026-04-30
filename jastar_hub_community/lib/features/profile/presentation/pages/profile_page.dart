import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/data/mock_data.dart';
import 'package:jastar_hub_community/features/home/presentation/widgets/event_card_widget.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EventRepository _eventRepository = EventRepository();

  List<EventModel> _joinedEvents = [];
  List<EventModel> _organizedEvents = [];
  bool _isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserEvents();
  }

  Future<void> _loadUserEvents() async {
    try {
      final joined = await _eventRepository.getJoinedEvents();
      final organized = await _eventRepository.getOrganizedEvents();
      if (mounted) {
        setState(() {
          _joinedEvents = joined;
          _organizedEvents = organized;
          _isLoadingEvents = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingEvents = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        UserModel user;
        if (authState is AuthAuthenticated) {
          user = authState.user;
        } else {
          user = MockData.currentUser;
        }

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          appBar: AppBar(
            title: Text(
              context.tr('nav_profile'),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (user.role == 'ADMIN')
                IconButton(
                  onPressed: () => context.push('/admin'),
                  icon: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    user.avatarUrl.isNotEmpty ? user.avatarUrl : MockData.currentUser.avatarUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(user.email, style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(user.rank, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(user.bio, style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5), textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard(context, user.points.toString(), 'Очки', isDark),
                            _buildStatCard(context, user.followers.toString(), 'Followers', isDark),
                            _buildStatCard(context, user.following.toString(), 'Following', isDark),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.interests.map((interest) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              child: Text(context.tr(interest), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      indicatorColor: AppColors.primary,
                      tabs: const [Tab(text: 'Я иду'), Tab(text: 'Я организовал')],
                    ),
                    isDark,
                  ),
                ),
              ];
            },
            body: _isLoadingEvents
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _joinedEvents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.event_available_rounded, size: 64, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                  const SizedBox(height: 16),
                                  Text('Вы пока никуда не идете', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: _joinedEvents.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: EventCardWidget(
                                    event: _joinedEvents[index],
                                    onTap: () => context.push('/events/${_joinedEvents[index].id}', extra: _joinedEvents[index]),
                                  ),
                                );
                              },
                            ),
                      _organizedEvents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.event_seat_rounded, size: 64, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                  const SizedBox(height: 16),
                                  Text('Вы еще не организовали события', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: _organizedEvents.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: EventCardWidget(
                                    event: _organizedEvents[index],
                                    onTap: () => context.push('/events/${_organizedEvents[index].id}', extra: _organizedEvents[index]),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, bool isDark) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final bool isDark;

  _SliverAppBarDelegate(this._tabBar, this.isDark);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
