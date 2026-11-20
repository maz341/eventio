import 'package:eventio/app/navigation/maps_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/events_viewmodel.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventsViewModel>();

    if (viewModel.isBookmarksLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.bookmarksError != null &&
        viewModel.bookmarkedEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(viewModel.bookmarksError!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: viewModel.loadBookmarks,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (viewModel.bookmarkedEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 56),
            SizedBox(height: 12),
            Text('No saved events yet'),
            SizedBox(height: 6),
            Text('Bookmark events to see them here.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.bookmarkedEvents.length,
      itemBuilder: (context, index) {
        final event = viewModel.bookmarkedEvents[index];

        return EventCard(
          event: event,
          distanceKm: viewModel.distanceTo(event),
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
    );
  }
}
