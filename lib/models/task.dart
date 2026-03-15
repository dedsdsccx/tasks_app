class Task { 
  final String id;
  final String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Конвертация в Map для сохранения в Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted, //g
    };
  }

  // Создание объекта из Map (чтение из Hive)
  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}