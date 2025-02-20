import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, bool>((ref) => ThemeViewModel());

class ThemeViewModel extends StateNotifier<bool> {
  ThemeViewModel({bool? isInitialModeDark})
      : super(isInitialModeDark ?? _loadTheme());

  static bool _loadTheme() {
    final box = Hive.box("settings");
    return box.get("isDarkMode", defaultValue: false);
  }

  void toggleTheme() {
    state = !state;
    Hive.box("settings").put("isDarkMode", state);
  }
}
