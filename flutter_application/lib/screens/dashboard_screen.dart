import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _sensorData = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ApiService.getSensorData(minutes: 10);
      setState(() { _sensorData = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<FlSpot> _toSpots(String field) {
    return _sensorData.asMap().entries.map((e) {
      final val = e.value[field];
      return FlSpot(e.key.toDouble(), (val as num).toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Actuator control card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actuator Control',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ApiService.sendActuatorCommand('TURN_ON');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Actuator ON sent')));
                          }
                        },
                        icon: const Icon(Icons.power),
                        label: const Text('TURN ON'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ApiService.sendActuatorCommand('TURN_OFF');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Actuator OFF sent')));
                          }
                        },
                        icon: const Icon(Icons.power_off),
                        label: const Text('TURN OFF'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sensor chart card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Acceleration (last 10 min)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else if (_error != null)
                    Center(child: Text('Error: $_error',
                        style: const TextStyle(color: Colors.red)))
                  else if (_sensorData.isEmpty)
                    const Center(child: Text('No sensor data available'))
                  else
                    SizedBox(
                      height: 200,
                      child: LineChart(LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: _toSpots('X'),
                            color: Colors.red,
                            dotData: const FlDotData(show: false),
                            barWidth: 1.5,
                          ),
                          LineChartBarData(
                            spots: _toSpots('Y'),
                            color: Colors.green,
                            dotData: const FlDotData(show: false),
                            barWidth: 1.5,
                          ),
                          LineChartBarData(
                            spots: _toSpots('Z'),
                            color: Colors.blue,
                            dotData: const FlDotData(show: false),
                            barWidth: 1.5,
                          ),
                        ],
                        titlesData: const FlTitlesData(show: false),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                      )),
                    ),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _legend(Colors.red, 'X'),
                    const SizedBox(width: 16),
                    _legend(Colors.green, 'Y'),
                    const SizedBox(width: 16),
                    _legend(Colors.blue, 'Z'),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 4),
      Text(label),
    ]);
  }
}