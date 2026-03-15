import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'package:flutter_application_1/service/storage_service.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Task> _tasks = [];
  bool _isLoaded = false;

  // Инициализация
  Future<void> init() async {
    await StorageService.init();
    _tasks = StorageService.getTasks();
    _isLoaded = true;
    notifyListeners();
    print('✅ Загружено задач: ${_tasks.length}');
  }

  // Геттер задач
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Добавить задачу
  Future<void> addTask(String title) async {
    if (title.isEmpty) return;
    final newTask = Task(id: _uuid.v4(), title: title);
    _tasks.add(newTask);
    await StorageService.saveTasks(_tasks);
    notifyListeners();
    print('✅ Задача добавлена: $title');
  }

  // Переключить статус
  Future<void> toggleTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await StorageService.saveTasks(_tasks);
      notifyListeners();
      print('✅ Задача обновлена: ${task.title}');
    }
  }

  // Удалить задачу
  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    await StorageService.saveTasks(_tasks);
    notifyListeners();
    print('✅ Задача удалена: ${task.title}');
  }

  // Очистить всё
  Future<void> clearAll() async {
    _tasks.clear();
    await StorageService.clear();
    notifyListeners();
  }
}