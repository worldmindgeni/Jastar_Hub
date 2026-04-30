import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/constants/app_constants.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/widgets/shimmer_loader.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/events_cubit.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/recommendations_cubit.dart';
import 'package:jastar_hub_community/features/notifications/presentation/notifications_cubit.dart';
import 'package:jastar_hub_community/shared/data/mock_data.dart';
import 'package:jastar_hub_community/features/home/presentation/widgets/event_card_widget.dart';
import 'package:jastar_hub_community/features/home/presentation/widgets/section_header.dart';

/// Home page with AI-powered event feed, categories, and carousels.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = (authState is AuthAuthenticated)
            ? authState.user
            : MockData.currentUser; // Fallback to avoid null errors during dev

        return Scaffold(
          body: BlocBuilder<EventsCubit, EventsState>(
            builder: (context, eventsState) {
              final events = (eventsState is EventsLoaded) ? eventsState.events : [];
              final isLoading = eventsState is EventsLoading;

              return RefreshIndicator(
                onRefresh: () => context.read<EventsCubit>().fetchEvents(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
          // ─── App Bar ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty ? user.name[0] : 'U',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Greeting
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tr('home_greeting')}, ${user.name.split(' ').first}! 👋',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            context.tr('app_tagline'),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification bell with real unread count
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, notifState) {
                        final unreadCount = (notifState is NotificationsLoaded)
                            ? notifState.unreadCount
                            : 0;
                        return GestureDetector(
                          onTap: () => context.push('/notifications'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.cardDark
                                  : AppColors.surfaceLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    size: 22,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.accent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          unreadCount > 9 ? '9+' : '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Search Bar ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.search_rounded,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.tr('search'),
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Categories ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: context.tr('categories'),
                  icon: Icons.category_rounded,
                ),
                SizedBox(
                  height: 46,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: MockData.categoriesData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCategoryChip(
                          context,
                          key: 'all',
                          label: 'All',
                          color: AppColors.primary,
                          isDark: isDark,
                        );
                      }
                      final cat = MockData.categoriesData[index - 1];
                      return _buildCategoryChip(
                        context,
                        key: cat['key'] as String,
                        label: context.tr(cat['key'] as String),
                        color: Color(cat['color'] as int),
                        isDark: isDark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ─── Recommended For You ──────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: context.tr('recommended_for_you'),
                  actionText: context.tr('see_all'),
                  onActionTap: () {},
                  icon: Icons.auto_awesome_rounded,
                ),
                const SizedBox(height: 8),
                BlocBuilder<RecommendationsCubit, EventsState>(
                  builder: (context, recState) {
                    final recEvents = (recState is EventsLoaded) ? recState.events : [];
                    final isRecLoading = recState is EventsLoading;

                    if (isRecLoading) return _buildShimmerList(isCompact: true);
                    
                    return SizedBox(
                      height: AppConstants.eventCardHeight + 10,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: recEvents.length,
                        itemBuilder: (context, index) {
                          return EventCardWidget(
                            event: recEvents[index],
                            isCompact: true,
                            onTap: () => context.push('/events/${recEvents[index].id}', extra: recEvents[index]),
                            onFavoriteTap: () {},
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ─── Trending Now ─────────────────────────────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: context.tr('trending_now'),
              actionText: context.tr('see_all'),
              onActionTap: () {},
              icon: Icons.trending_up_rounded,
            ),
          ),
          SliverToBoxAdapter(
            child: Builder(
              builder: (context) {
                // Use loaded events sorted by attendees as trending
                final trendingEvents = List.of(events)
                  ..sort((a, b) => b.attendees.compareTo(a.attendees));
                final topTrending = trendingEvents.take(5).toList();

                if (isLoading) return _buildShimmerList(isCompact: true);

                return SizedBox(
                  height: AppConstants.eventCardHeight + 10,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: topTrending.length,
                    itemBuilder: (context, index) {
                      return EventCardWidget(
                        event: topTrending[index],
                        isCompact: true,
                        onTap: () => context.push('/events/${topTrending[index].id}', extra: topTrending[index]),
                        onFavoriteTap: () {},
                      );
                    },
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ─── Nearby Events (full-width cards) ─────────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: context.tr('nearby_events'),
              actionText: context.tr('see_all'),
              onActionTap: () {},
              icon: Icons.location_on_rounded,
            ),
          ),
          if (isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: const ShimmerLoader(
                      height: 180,
                      width: double.infinity,
                      borderRadius: 16,
                    ),
                  ),
                  childCount: 3,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= events.length) return null;
                    return EventCardWidget(
                      event: events[index],
                      onTap: () {},
                      onFavoriteTap: () {},
                    );
                  },
                  childCount: events.length > 5 ? 5 : events.length,
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  },
),
);
},
);
}

Widget _buildShimmerList({required bool isCompact}) {
return SizedBox(
  height: isCompact ? AppConstants.eventCardHeight + 10 : 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: 3,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ShimmerLoader(
        width: isCompact ? 200 : 300,
        height: isCompact ? AppConstants.eventCardHeight : 200,
        borderRadius: 16,
      ),
    ),
  ),
);
}

  Widget _buildCategoryChip(
    BuildContext context, {
    required String key,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.8)])
              : null,
          color: isSelected
              ? null
              : (isDark
                  ? AppColors.cardDark
                  : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.borderDark
                      : color.withValues(alpha: 0.2),
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textSecondaryDark : color),
          ),
        ),
      ),
    );
  }
}
