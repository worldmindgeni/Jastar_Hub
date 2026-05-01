import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/constants/app_constants.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:intl/intl.dart';

/// Premium event card widget for carousels and lists.
class EventCardWidget extends StatefulWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isCompact;

  const EventCardWidget({
    super.key,
    required this.event,
    this.onTap,
    this.onFavoriteTap,
    this.isCompact = false,
  });

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    final cat = widget.event.category.toLowerCase();
    switch (cat) {
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
    final dateFormat = DateFormat('d MMM, HH:mm', 'ru');

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _pressController.reverse(),
        child: Container(
          width: widget.isCompact ? AppConstants.eventCardWidth : double.infinity,
          height: widget.isCompact ? AppConstants.eventCardHeight : null,
          margin: widget.isCompact
              ? const EdgeInsets.only(right: 16)
              : const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark.withValues(alpha: 0.5)
                  : AppColors.borderLight.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: catColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadiusLg),
                ),
                child: Stack(
                  children: [
                    // Event image
                    SizedBox(
                      width: double.infinity,
                      height: widget.isCompact ? 120 : 160,
                      child: CachedNetworkImage(
                        imageUrl: widget.event.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context2, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                catColor.withValues(alpha: 0.3),
                                catColor.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: catColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        errorWidget: (context2, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                catColor.withValues(alpha: 0.4),
                                catColor.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.event_rounded,
                              size: 40,
                              color: catColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Category badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: catColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          context.tr(widget.event.category),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavoriteTap,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black54
                                : Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.event.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18,
                            color: widget.event.isFavorite
                                ? AppColors.accent
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          ),
                        ),
                      ),
                    ),

                    // Price badge
                    if (!widget.event.isFree)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black87 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            '${widget.event.price.toInt()} ₸',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ),
                    if (widget.event.isFree)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            context.tr('free'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: EdgeInsets.all(widget.isCompact ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      widget.event.title,
                      style: TextStyle(
                        fontSize: widget.isCompact ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: widget.isCompact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: widget.isCompact ? 6 : 10),

                    // Date & time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: catColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dateFormat.format(widget.event.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),


                    if (!widget.isCompact) ...[
                      const SizedBox(height: 6),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.event.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Attendees bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: widget.event.fillPercentage,
                                backgroundColor: isDark
                                    ? AppColors.cardDarkElevated
                                    : AppColors.shimmerBaseLight,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(catColor),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${widget.event.attendees}/${widget.event.maxAttendees}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


