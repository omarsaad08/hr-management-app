import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hr_management_app/data/sockets/storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    // Initialize FlutterLocalNotificationsPlugin
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Configure notification settings (Android)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void connectAndListen(String clientId, String role) async {
    socket = IO.io('http://16.171.199.210:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket!.onConnect((_) {
      print('Socket connected with ID: ${socket!.id}');
      // Emit clientId and role as an object
      Map<String, dynamic> emitData = {'clientId': clientId, 'role': role};
      socket!.emit('client_id', emitData); // Emit object to the server
    });
    socket!.onDisconnect((_) => print('Socket disconnected'));
    // Listen for 'message_to_client' event
    socket!.on('message_to_client', (data) {
      print('recieved action from server: $data');
      StorageServices.saveMessage(data.toString());
      _showNotification(data.toString());
    });
  }

  static void disconnectSocket() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      print('Socket disconnected');
    }
  }

  static Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your_channel_id', // Change this to your channel ID
            'HRManager', // Change this to your channel name
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ledColor: Color.fromARGB(
                255, 255, 0, 0), // LED color (red in this example)
            ledOnMs: 1000,
            ledOffMs: 500);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (unique)
      'New Message from HR system !', // Notification title
      message,
      platformChannelSpecifics,
    );
  }
}
