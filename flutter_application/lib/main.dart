import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/websocket_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/events_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WebSocketService()..connect(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const EventsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<WebSocketService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.circle,
              color: ws.isConnected ? Colors.green : Colors.red,
              size: 14,
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}