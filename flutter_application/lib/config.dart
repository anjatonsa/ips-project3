class AppConfig {
  // Put your Raspberry Pi IP here
  static const String piHost = 'rpi4.local';
  static const int apiPort = 8000;

  static String get baseUrl => 'http://$piHost:$apiPort';
  static String get wsUrl   => 'ws://$piHost:$apiPort/ws';
}