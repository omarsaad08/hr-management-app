import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future<void> saveMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList('messages') ?? [];
    messages.add(message);
    await prefs.setStringList('messages', messages);
  }

  static Future<List<String>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('messages') ?? [];
  }
}
