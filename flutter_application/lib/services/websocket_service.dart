import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  final List<Map<String, dynamic>> events = [];
  bool isConnected = false;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));
      isConnected = true;
      notifyListeners();

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['type'] == 'ping') return;
          if (data['type'] == 'movement') {
            events.insert(0, data);
            if (events.length > 50) events.removeLast();
            notifyListeners();
          }
        },
        onDone: () {
          isConnected = false;
          notifyListeners();
          Future.delayed(const Duration(seconds: 3), connect);
        },
        onError: (_) {
          isConnected = false;
          notifyListeners();
          Future.delayed(const Duration(seconds: 3), connect);
        },
      );
    } catch (e) {
      isConnected = false;
      Future.delayed(const Duration(seconds: 3), connect);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    isConnected = false;
  }
}