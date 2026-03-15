import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // Важно: обеспечиваем инициализацию Flutter перед использованием Hive
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем провайдер и загружаем данные
  final taskProvider = TaskProvider();
  await taskProvider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: taskProvider,
      child: const MyApp(),
    ),
  ); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}