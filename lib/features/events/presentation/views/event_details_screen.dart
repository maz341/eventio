import 'package:eventio/app/navigation/maps_launcher.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../shared/widgets/app_cached_image.dart';
import '../../domain/models/event.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.mapsLauncher,
  });

  final Event event;
  final MapsLauncher mapsLauncher;

  Future<void> _openDirections(BuildContext context) async {
    try {
      final opened = await mapsLauncher.openDirections(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open directions.')),
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong opening maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(
      context,
    ).formatMediumDate(event.startsAt);

    final time = TimeOfDay.fromDateTime(event.startsAt).format(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: AppCachedImage(imageUrl: event.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    text: '$date at $time',
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    text: event.location,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openDirections(context),
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.coral, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
