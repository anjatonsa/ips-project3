import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<WebSocketService>();
    final events = ws.events;

    if (events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No movement events yet',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 8),
            Text('Events appear here in real time\nwhen vibration is detected',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final e = events[i];
        final isOn = e['command'] == 'TURN_ON';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isOn ? Colors.orange.shade100 : Colors.green.shade100,
              child: Icon(
                isOn ? Icons.warning_amber : Icons.check_circle,
                color: isOn ? Colors.orange : Colors.green,
              ),
            ),
            title: Text(
              isOn ? 'Movement Detected' : 'Movement Stopped',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Time: ${e['timestamp']}',
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}