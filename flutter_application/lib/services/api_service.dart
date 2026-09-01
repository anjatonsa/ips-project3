import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> getSensorData({int minutes = 10}) async {
    try {
      final res = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/sensors?minutes=$minutes'),
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(body['data']);
      }
    } catch (e) {
      debugPrint('getSensorData error: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.baseUrl}/api/events'));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(body['events']);
      }
    } catch (e) {
      debugPrint('getEvents error: $e');
    }
    return [];
  }

  static Future<double> getThreshold() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.baseUrl}/api/config'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['threshold'].toDouble();
      }
    } catch (e) {
      debugPrint('getThreshold error: $e');
    }
    return 0.5;
  }

  static Future<bool> setThreshold(double value) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/config/threshold'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'threshold': value}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('setThreshold error: $e');
      return false;
    }
  }

  static Future<bool> sendActuatorCommand(String command) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/actuator'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'command': command}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('sendActuatorCommand error: $e');
      return false;
    }
  }
}