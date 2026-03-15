import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Map> _box;
  final _uuid = const Uuid();
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      // Открываем бокс с данными
      _box = await Hive.openBox<Map>('tasks_box');
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Ошибка инициализации Hive: $e');
      // В вебе это может случиться, если включен режим инкогнито
      _isInitialized = false;
    }
  }

  List<Task> get tasks {
    if (!_isInitialized) return [];
    return _box.values.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> addTask(String title) async {
    if (title.isEmpty || !_isInitialized) return;
    final newTask = Task(id: _uuid.v4(), title: title);
    await _box.add(newTask.toMap());
    notifyListeners();
  }

  Future<void> toggleTask(Task task) async {
    if (!_isInitialized) return;
    final key = _box.values.toList().indexWhere((m) => m['id'] == task.id);
    if (key != -1) {
      task.isCompleted = !task.isCompleted;
      await _box.putAt(key, task.toMap());
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    if (!_isInitialized) return;
    final key = _box.values.toList().indexWhere((m) => m['id'] == task.id);
    if (key != -1) {
      await _box.deleteAt(key);
      notifyListeners();
    }
  }
}