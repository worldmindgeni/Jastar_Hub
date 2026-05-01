import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';
import 'package:jastar_hub_community/features/home/presentation/widgets/event_card_widget.dart';

class AiRecommendationsWidget extends StatefulWidget {
  const AiRecommendationsWidget({super.key});

  @override
  State<AiRecommendationsWidget> createState() => _AiRecommendationsWidgetState();
}

class _AiRecommendationsWidgetState extends State<AiRecommendationsWidget> {
  final EventRepository _repo = EventRepository();
  List<EventModel> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAiRecommendations();
  }

  Future<void> _fetchAiRecommendations() async {
    try {
      final recs = await _repo.getRecommendations();
      if (mounted) {
        setState(() {
          _recommendations = recs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink(); // Hide if no recommendations found
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              Text(
                'AI Рекомендации для вас',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 380, // EventCardWidget approx height
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final event = _recommendations[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 320,
                  child: EventCardWidget(
                    event: event,
                    onTap: () => context.push('/events/${event.id}', extra: event),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
