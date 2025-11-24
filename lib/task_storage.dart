import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';

class TaskStorage {
  static const String key = 'tasks';


  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskLists = tasks.map((t) => t.toList()).toList();
    prefs.setStringList(
        key, taskLists.map((list) => list.join('|')).toList());
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(key);
    if (stored == null) return [];

    return stored.map((s) => Task.fromList(s.split('|'))).toList();
  }
}
