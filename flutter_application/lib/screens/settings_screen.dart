import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _threshold = 0.5;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadThreshold();
  }

  Future<void> _loadThreshold() async {
    final t = await ApiService.getThreshold();
    setState(() { _threshold = t; _loading = false; });
  }

  Future<void> _saveThreshold() async {
    setState(() => _saving = true);
    final ok = await ApiService.setThreshold(_threshold);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Threshold updated to ${_threshold.toStringAsFixed(2)}' : 'Failed to update'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ML Anomaly Threshold',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  _threshold.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lower = more sensitive (more false alarms)\nHigher = less sensitive (may miss anomalies)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _threshold,
                  min: 0.1,
                  max: 0.9,
                  divisions: 8,
                  label: _threshold.toStringAsFixed(2),
                  onChanged: (v) => setState(() => _threshold = v),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('0.1\nMore sensitive',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const Text('0.9\nLess sensitive',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _saveThreshold,
                    child: _saving
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Save Threshold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}