import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/events_cubit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LatLng _initialCenter = const LatLng(43.2389, 76.9458); // Almaty Center
  EventModel? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          final events = (state is EventsLoaded) ? state.events : [];

          return Stack(
            children: [
              // ─── Map ────────────────────────────────────
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 12.0,
                  onTap: (pos, point) => setState(() => _selectedEvent = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'kz.jastarhub.community',
                    tileBuilder: isDark ? _darkModeTileBuilder : null,
                  ),
                  MarkerLayer(
                    markers: events.map((event) {
                      return Marker(
                        point: LatLng(event.latitude, event.longitude),
                        width: 48,
                        height: 48,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedEvent = event);
                            _mapController.move(
                              LatLng(event.latitude - 0.01, event.longitude),
                              14.0,
                            );
                          },
                          child: AnimatedScale(
                            scale: _selectedEvent?.id == event.id ? 1.2 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(event.category),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getCategoryColor(event.category).withValues(alpha: 0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.event_rounded, color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ─── Header Overlay ───────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.my_location_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('map'),
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Event Bottom Sheet ───────────────────
              if (_selectedEvent != null)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () => context.push('/events/${_selectedEvent!.id}', extra: _selectedEvent!),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: _selectedEvent!.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedEvent!.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            _selectedEvent!.location,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'technology': return AppColors.categoryTech;
      case 'sports': return AppColors.categorySports;
      case 'music': return AppColors.categoryMusic;
      case 'art': return AppColors.categoryArt;
      case 'food': return AppColors.categoryFood;
      default: return AppColors.primary;
    }
  }

  Widget _darkModeTileBuilder(BuildContext context, Widget tileWidget, TileImage tile) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        -1,  0,  0, 0, 255,
         0, -1,  0, 0, 255,
         0,  0, -1, 0, 255,
         0,  0,  0, 1,   0,
      ]),
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: tileWidget,
      ),
    );
  }
}
