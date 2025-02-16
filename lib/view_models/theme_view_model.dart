import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeStateNotifier =
    StateNotifierProvider<ThemeViewModel, bool>((ref) => ThemeViewModel());

class ThemeViewModel extends StateNotifier<bool> {
  ThemeViewModel({bool? isInitialModeDark}) : super(isInitialModeDark ?? _loadTheme());

  static bool _loadTheme() {
    final box = Hive.box("settings");
    return box.get("isDarkMode", defaultValue: false);
  }

  void toggleTheme() {
    state = !state;
    Hive.box("settings").put("isDarkMode", state);
  }
}

final sortPreferenceProvider = StateNotifierProvider<SortPreferenceViewModel, String>(
      (ref) => SortPreferenceViewModel(),
);

class SortPreferenceViewModel extends StateNotifier<String> {
  SortPreferenceViewModel() : super(_loadSortPreference());

  static String _loadSortPreference() {
    final box = Hive.box("settings");
    return box.get("sortBy", defaultValue: "date");
  }

  void updateSortPreference(String sortBy) {
    state = sortBy;
    Hive.box("settings").put("sortBy", state);
  }
}

