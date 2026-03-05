import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
// import 'presentation/providers/theme_provider.dart';
import 'data/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/alert_history.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AlertHistoryAdapter());
  await Hive.openBox('alerts');

  await NotificationService.init(); // IMPORTANT

  // await FlutterForegroundTask.startService(
  //   notificationTitle: 'Monitoring',
  //   notificationText: 'Temperature monitoring active',
  // );


  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temp & Humidity Monitor',
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}