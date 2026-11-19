import 'package:eventio/app/navigation/maps_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/events_viewmodel.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventsViewModel>();

    if (viewModel.isLoading && viewModel.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null && viewModel.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(viewModel.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => viewModel.loadEvents(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (viewModel.events.isEmpty) {
      return const Center(child: Text('No events available yet.'));
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadEvents(forceRefresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.events.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Events',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (viewModel.isStale) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Showing saved events. Unable to fetch updates.',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (viewModel.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Unable to refresh events.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          final event = viewModel.events[index - 1];

          return EventCard(
            event: event,

            isBookmarked: viewModel.isBookmarked(event.id),

            onBookmarkPressed: viewModel.isBookmarkSaving(event.id)
                ? null
                : () async {
                    final success = await viewModel.toggleBookmark(event.id);

                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not update bookmark.'),
                        ),
                      );
                    }
                  },

            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EventDetailsScreen(
                    event: event,
                    mapsLauncher: const MapsLauncher(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
