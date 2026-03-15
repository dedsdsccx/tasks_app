import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Настройка пути для Hive
  if (Hive.isPlatformSupported) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Для мобильных устройств стандартная инициализация
      await Hive.initFlutter();
    } else {
      // Для Web (и Desktop) нужно указать директорию явно
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
  }

  // 2. Инициализация провайдера и открытие базы
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
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}