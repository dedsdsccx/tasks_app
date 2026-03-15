import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Map> _box;
  final _uuid = const Uuid();

  // Инициализация базы данных
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<Map>('tasks_box');
    notifyListeners(); // Обновляем UI после загрузки
  }

  // Получение списка задач
  List<Task> get tasks {
    return _box.values.map((map) => Task.fromMap(map)).toList();
  }

  // Добавление задачи
  Future<void> addTask(String title) async {
    if (title.isEmpty) return;
    
    final newTask = Task(id: _uuid.v4(), title: title);
    await _box.add(newTask.toMap());
    notifyListeners();
  }

  // Переключение статуса (выполнено/нет)
  Future<void> toggleTask(Task task) async {
    // Находим ключ в базе по ID задачи
    final key = _box.values.toList().indexWhere((m) => m['id'] == task.id);
    if (key != -1) {
      task.isCompleted = !task.isCompleted;
      await _box.putAt(key, task.toMap());
      notifyListeners();
    }
  }

  // Удаление задачи
  Future<void> deleteTask(Task task) async {
    final key = _box.values.toList().indexWhere((m) => m['id'] == task.id);
    if (key != -1) {
      await _box.deleteAt(key);
      notifyListeners();
    }
  }
}