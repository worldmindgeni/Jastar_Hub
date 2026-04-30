import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';

import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:jastar_hub_community/shared/widgets/app_button.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({super.key, required this.event});

  Color _getCategoryColor() {
    switch (event.category) {
      case 'technology':
        return AppColors.categoryTech;
      case 'sports':
        return AppColors.categorySports;
      case 'music':
        return AppColors.categoryMusic;
      case 'art':
        return AppColors.categoryArt;
      case 'food':
        return AppColors.categoryFood;
      case 'education':
        return AppColors.categoryEducation;
      case 'business':
        return AppColors.categoryBusiness;
      case 'culture':
        return AppColors.categoryCulture;
      case 'wellness':
        return AppColors.categoryWellness;
      case 'entertainment':
        return AppColors.categoryEntertainment;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _getCategoryColor();
    final dateFormat = DateFormat('d MMMM yyyy, HH:mm', 'ru');

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Parallax App Bar ───────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: Colors.white,
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      event.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: event.isFavorite ? AppColors.accent : Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: event.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: catColor.withValues(alpha: 0.2)),
                        errorWidget: (context, url, error) => Container(color: catColor.withValues(alpha: 0.2)),
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Content ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  transform: Matrix4.translationValues(0, -32, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: catColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            context.tr(event.category),
                            style: TextStyle(
                              color: catColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          event.title,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 26),
                        ),
                        const SizedBox(height: 24),

                        // Time & Location Info Row
                        _buildInfoRow(
                          context,
                          icon: Icons.calendar_today_rounded,
                          color: catColor,
                          title: dateFormat.format(event.date),
                          subtitle: 'Добавить в календарь',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          icon: Icons.location_on_rounded,
                          color: AppColors.accent,
                          title: event.location,
                          subtitle: event.city,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 32),

                        // Organizer Profile
                        Text(
                          context.tr('organizer'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: CachedNetworkImageProvider(event.organizerAvatar),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.organizerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Организатор проверенный',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              text: 'Folllow',
                              variant: AppButtonVariant.outlined,
                              height: 36,
                              isFullWidth: false,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Description
                        Text(
                          context.tr('about_event'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          event.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Attendees
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${event.attendees} ${context.tr('attendees')}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              '${event.maxAttendees} max',
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: event.fillPercentage,
                            backgroundColor: isDark ? AppColors.cardDarkElevated : AppColors.shimmerBaseLight,
                            valueColor: AlwaysStoppedAnimation<Color>(catColor),
                            minHeight: 8,
                          ),
                        ),

                        // Extra padding for fixed bottom bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── Fixed Bottom Action Bar ──────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('price'),
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        event.isFree ? context.tr('free') : '${event.price.toInt()} ₸',
                        style: TextStyle(
                          color: event.isFree ? AppColors.success : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: AppButton(
                      text: event.isJoined ? context.tr('leave_event') : context.tr('join_event'),
                      variant: event.isJoined ? AppButtonVariant.outlined : AppButtonVariant.gradient,
                      onPressed: () {
                        // Toggle join logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
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
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
