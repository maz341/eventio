import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/event.dart';

class EventsApiService {
  EventsApiService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<Event>> fetchEvents() async {
    final url = Uri.parse('$baseUrl/events');

    final response = await client.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load events: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data.map((item) {
      return Event.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
