# IoT Android Dashboard – Project 3

This project is a **mobile Android application developed as an extension of ips-project2**.

The application represents the control dashboard of the IoT system and allows the user to monitor sensor data, receive ML/DL detection events, configure system parameters, and control simulated actuators.

The application is developed using **Flutter** and the **Dart** programming language.

---

## Project 3 as an Extension of Project 2

Project 2 implemented the core IoT system, including:

* Arduino Nano 33 BLE Sense Lite for sensor data acquisition
* MQTT communication using Mosquitto
* Raspberry Pi 4 as the SBC
* ML model for movement/anomaly detection
* InfluxDB for storing sensor data
* Simulated actuator control

Project 3 extends this system by adding:

* A **api-service**  running on the Raspberry Pi
* A **Flutter Android application**
* REST API communication between the application and the SBC
* WebSocket communication for real-time event notifications

The **api-service** acts as the communication layer between the existing IoT system and the new mobile dashboard.

---

## Mobile Application Features

The Flutter application contains three main screens:

```text
Dashboard
Events
Settings
```

### Dashboard

The Dashboard displays sensor data collected by the Arduino.

Currently displayed sensor values include:

* X-axis acceleration
* Y-axis acceleration
* Z-axis acceleration

The data is retrieved from the REST API.

Example endpoint:

```text
GET /api/sensors?minutes=10
```

The **api-service** service retrieves the requested data from InfluxDB and returns it to the mobile application.

---

### Events

The Events screen displays events detected by the ML model.

When the ML service detects movement/anomaly, an event is sent through MQTT to the **api-service** service.

The **api-service** service then sends the event to connected mobile applications using WebSocket.

---

### Settings

The Settings screen allows the user to configure system parameters.

Currently supported configuration:

* ML detection threshold

The current threshold can be retrieved using:

```text
GET /api/config
```

A new threshold can be sent using:

```text
POST /api/config/threshold
```

The FastAPI service then publishes the new configuration through MQTT.

The threshold must be between `0` and `1`.

---

### Actuator Control

The application allows the user to trigger simulated actuator actions.

Supported commands:

```text
TURN_ON
TURN_OFF
```

The command is sent to the FastAPI service:

```text
POST /api/actuator
```

The FastAPI service publishes the command to the MQTT command topic.

This allows the mobile application to control the simulated actuator through the existing IoT communication infrastructure.

---


## Flutter Project Structure

```text
lib/
│
├── main.dart
├── config.dart
│
├── services/
│   ├── api_service.dart
│   └── websocket_service.dart
│
└── screens/
    ├── dashboard_screen.dart
    ├── events_screen.dart
    └── settings_screen.dart
```

### `main.dart`

The main entry point of the Flutter application.

It initializes the application and creates the `WebSocketService`.

```dart
WebSocketService()..connect()
```

The application contains three main screens:

* Dashboard
* Events
* Settings

---

### `config.dart`

Contains the connection configuration for the Raspberry Pi.

It defines:

* Raspberry Pi hostname
* API port
* REST API URL
* WebSocket URL

---

### `api_service.dart`

Contains functions responsible for REST API communication.

Implemented operations include:

```text
getSensorData()
getEvents()
getThreshold()
setThreshold()
sendActuatorCommand()
```

---

### `websocket_service.dart`

Manages the WebSocket connection with the FastAPI service.

It is responsible for:

* Establishing the WebSocket connection
* Receiving events
* Storing received events
* Updating the application state
* Detecting connection loss
* Automatically reconnecting

The service uses `ChangeNotifier` together with the `Provider` package for state management.

---

## Running the Application

Make sure Flutter and the Android development environment are installed.

Check the Flutter installation:

```bash
flutter doctor
```

Install project dependencies:

```bash
flutter pub get
```

Check connected devices:

```bash
flutter devices
```

Run the application on a connected Android device:

```bash
flutter run -d <DEVICE_ID>
```

Example:

```bash
flutter run -d RZCW80BJJAM
```

---

## Building the Release APK

To create a release APK:

```bash
flutter build apk --release
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The release APK can then be installed directly on the Android device.

---
