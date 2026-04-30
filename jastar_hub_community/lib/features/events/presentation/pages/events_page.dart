import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/constants/app_constants.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/data/mock_data.dart';
import 'package:jastar_hub_community/shared/widgets/shimmer_loader.dart';
import 'package:jastar_hub_community/features/home/presentation/widgets/event_card_widget.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/events_cubit.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          context.tr('nav_events'),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Open filter modal
            },
            icon: Icon(
              Icons.filter_list_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          final events = (state is EventsLoaded) ? state.events : [];
          final isLoading = state is EventsLoading;

          return RefreshIndicator(
            onRefresh: () => context.read<EventsCubit>().fetchEvents(category: _selectedCategory),
            child: Column(
              children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(
                        Icons.search_rounded,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) {
                            context.read<EventsCubit>().fetchEvents(
                              category: _selectedCategory,
                              search: value,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: context.tr('search'),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Horizontal List
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
              const SizedBox(height: 16),

              // Events List
              Expanded(
                child: isLoading
                    ? _buildShimmerList()
                    : (events.isEmpty
                        ? _buildEmptyState(isDark)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: EventCardWidget(
                                  event: event,
                                  onTap: () {
                                    context.push('/events/${event.id}', extra: event);
                                  },
                                  onFavoriteTap: () {
                                    // Toggle favorite logic
                                  },
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ShimmerLoader(
          height: 180,
          width: double.infinity,
          borderRadius: 16,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 64,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
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
      onTap: () {
        setState(() => _selectedCategory = key);
        context.read<EventsCubit>().fetchEvents(category: key);
      },
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.8)])
              : null,
          color: isSelected ? null : (isDark ? AppColors.cardDark : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : color.withValues(alpha: 0.2),
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
            color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : color),
          ),
        ),
      ),
    );
  }
}

