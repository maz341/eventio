import 'package:eventio/app/navigation/maps_launcher.dart';
import 'package:eventio/features/events/presentation/views/event_details_screen.dart';
import 'package:flutter/material.dart';

import '../../data/sample_events.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sampleEvents.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        }

        final event = sampleEvents[index - 1];

        return EventCard(
          event: event,
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
