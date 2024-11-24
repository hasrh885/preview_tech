import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _instance = Storage._internal();
  Storage._internal();
  factory Storage()=>_instance;

  Future<bool> save({required String key, required String value}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print('Error saving data: $e');
      return false;
    }
  }

  // Get a string from SharedPreferences
  read({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key);
  }

  // Get an integer from SharedPreferences
  Future<int?> getInt({required String key}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.getInt(key);
    } catch (e) {
      // Handle error
      print('Error reading data: $e');
      return null;
    }
  }

  // Update a session (For now, simply saving the session again)
  Future<void> updateSession({required String key, required String newValue}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await await prefs.setString(key, newValue);
    } catch (e) {
      // Handle error
      print('Error updating session: $e');
    }
  }

  // Remove a key from SharedPreferences (for deleting a session or clearing a specific entry)
  Future<void> remove({required String key}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      // Handle error
      print('Error removing data: $e');
    }
  }

  // // Clear all SharedPreferences data (to reset the app or clear all data)
  // Future<void> clearAll() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //   } catch (e) {
  //     // Handle error
  //     print('Error clearing all data: $e');
  //   }
  // }
}
