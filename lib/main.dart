import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/utility/app_theme.dart';
import 'package:task_management/view_models/theme_view_model.dart';
import 'package:task_management/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize & Open Hive box
  await Hive.initFlutter();
  await Hive.openBox("settings");

  // Load theme before running the app
  final isDarkMode =
      Hive.box("settings").get("isDarkMode", defaultValue: false);

  runApp(ProviderScope(
    overrides: [
      themeStateNotifier.overrideWith((ref) => ThemeViewModel(isInitialModeDark: isDarkMode))
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeStateNotifier);

    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
